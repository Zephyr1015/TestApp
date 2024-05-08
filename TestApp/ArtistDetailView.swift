//
//  ArtistDetailView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/07.
//

import SwiftUI

struct ArtistDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isEditingArtist = false
    
    private var artist: Artist
    @State private var name: String
    
    @FetchRequest private var albums: FetchedResults<Album>
    
    init(artist: Artist) {
        self.artist = artist
        self.name = artist.name ?? ""
        
        self._albums = FetchRequest<Album>(
            entity: Album.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Album.title, ascending: true)],
            predicate: NSPredicate(format: "ANY artists == %@", artist)
        )
    }
    
    var body: some View {
        VStack {
            Text(artist.name ?? "")
                .font(.title)
                .fontDesign(.rounded)
            
            if !albums.isEmpty {
                Text("Albums:")
                    .font(.headline)
                
                ForEach(albums) { album in
                    Text(album.title ?? "")
                }
            } else {
                Text("No albums found for this artist.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationBarItems(trailing: Button("Edit") {
            isEditingArtist = true
        })
        .sheet(isPresented: $isEditingArtist) {
            TextFieldAlert( // declared in GenreDetailView.swift
                isPresented: $isEditingArtist,
                text: $name,
                title: "Edit Artist",
                message: "Enter the new artist name:",
                placeholder: "Artist Name",
                action: saveArtist
            )
        }
    }
    
    private func saveArtist() {
        artist.name = name
        try? viewContext.save()
    }
}

//#Preview {
//    ArtistDetailView()
//}
