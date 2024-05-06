//
//  AddAlbumView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/06.
//

import SwiftUI

struct AddAlbumView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var artist = ""
    @State private var year = ""
    @State private var coverImageURL = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Album Details")) {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Cover Image URL", text: $coverImageURL)
                }
            }
            .navigationBarTitle("Add Album")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                if isYearValid() {
                    addAlbum()
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
    
    private func addAlbum() {
        let newAlbum = Album(context: viewContext)
        newAlbum.title = title
        newAlbum.artist = artist
        newAlbum.year = year
        newAlbum.coverImageURL = coverImageURL
        newAlbum.createdAt = Date()
        newAlbum.updatedAt = Date()
        
        try? viewContext.save()
        
        isPresented = false
    }
}

//#Preview {
//    AddAlbumView()
//}
