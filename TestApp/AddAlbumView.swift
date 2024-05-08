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
    @State private var year = ""
    @State private var coverImageURL = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedArtist: Set<Artist> = []
    @State private var showArtistSelection = false
    
    @State private var selectedGenres: Set<Genre> = []
    @State private var showGenreSelection = false
    
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
                        ArtistSelectionViewInAddView(selectedArtist: $selectedArtist)
                    }
                }
                
                Section(header: Text("Album Details")) {
                    TextField("Title", text: $title)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Cover Image URL", text: $coverImageURL)
                }
                
                Section(header: Text("Genres")) {
                    Button(action: {
                        showGenreSelection = true
                    }) {
                        Text("Select Genres")
                    }
                    .sheet(isPresented: $showGenreSelection) {
                        GenreSelectionViewInAddView(selectedGenres: $selectedGenres)
                    }
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
        newAlbum.year = year
        newAlbum.coverImageURL = coverImageURL
        newAlbum.createdAt = Date()
        newAlbum.updatedAt = Date()
        
        for genre in selectedGenres {
            newAlbum.addToGenres(genre)
        }
        
        for artist in selectedArtist {
            newAlbum.addToArtists(artist)
        }
        
        try? viewContext.save()
        
        isPresented = false
    }
}

struct ArtistSelectionViewInAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(entity: Artist.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Artist.name, ascending: true)])
    private var artists: FetchedResults<Artist>
    
    @Binding var selectedArtist: Set<Artist>
    
    @State private var isShowingAddArtistView = false
    
    var body: some View {
        NavigationView {
            List(artists) { artist in
                Button(action: {
                    toggleArtistSelection(artist)
                }) {
                    HStack {
                        Text(artist.name ?? "")
                        Spacer()
                        if selectedArtist.contains(artist) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationBarTitle("Select Artist")
            .navigationBarItems(trailing:
                HStack {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button(action: {
                        isShowingAddArtistView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
        }
        .sheet(isPresented: $isShowingAddArtistView) {
            AddArtistView(isPresented: $isShowingAddArtistView)
        }
    }
    
    private func toggleArtistSelection(_ artist: Artist) {
        if selectedArtist.contains(artist) {
            selectedArtist.remove(artist)
        } else {
            selectedArtist.insert(artist)
        }
    }
}

struct GenreSelectionViewInAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(entity: Genre.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Genre.name, ascending: true)])
    private var genres: FetchedResults<Genre>
    
    @Binding var selectedGenres: Set<Genre>
    
    @State private var isShowingAddGenreView = false
    
    var body: some View {
        NavigationView {
            List(genres) { genre in
                Button(action: {
                    toggleGenreSelection(genre)
                }) {
                    HStack {
                        Text(genre.name ?? "")
                        Spacer()
                        if selectedGenres.contains(genre) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationBarTitle("Select Genres")
            .navigationBarItems(trailing:
                HStack {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button(action: {
                        isShowingAddGenreView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
        }
        .sheet(isPresented: $isShowingAddGenreView) {
            AddGenreView(isPresented: $isShowingAddGenreView)
        }
    }
    
    private func toggleGenreSelection(_ genre: Genre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }
}

//#Preview {
//    AddAlbumView()
//}
