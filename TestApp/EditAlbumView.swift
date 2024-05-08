//
//  EditAlbumView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/06.
//

import SwiftUI

struct EditAlbumView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    private var album: Album
    
    @State private var title: String
    @State private var year: String
    @State private var coverImageURL: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
//    @State private var selectedArtist: Set<Artist> = []
    @State private var showArtistSelection = false
    @FetchRequest(entity: Artist.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Artist.name, ascending: true)])
    private var artists: FetchedResults<Artist>
    
    init(album: Album) {
        self.album = album
        self.title = album.title ?? ""
        self.coverImageURL = album.coverImageURL ?? ""
        self.year = album.year ?? ""
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Artist")) {
                    Button(action: {
                        showArtistSelection = true
                    }) {
                        Text("Select Artist")
                    }
                    .sheet(isPresented: $showArtistSelection) {
                        ArtistSelectionView(album: album)
                    }
                }
                
                Section(header: Text("Album Details")) {
                    TextField("Title", text: $title)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Cover Image URL", text: $coverImageURL)
                }
            }
            .navigationBarTitle("Edit Album")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if isYearValid() {
                    saveAlbum()
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showAlert = true
                    alertMessage = "Please enter a valid 4-digit year."
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Year"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func isYearValid() -> Bool {
        let yearRegex = "^\\d{4}$"
        let yearPredicate = NSPredicate(format: "SELF MATCHES %@", yearRegex)
        return yearPredicate.evaluate(with: year)
    }
    
    private func saveAlbum() {
        album.title = title
        album.year = year
        album.coverImageURL = coverImageURL
        album.updatedAt = Date()
        
        try? viewContext.save()
    }
}

//#Preview {
//    EditAlbumView()
//}
