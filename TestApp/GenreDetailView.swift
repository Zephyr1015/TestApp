//
//  GenreDetailView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/06.
//

import SwiftUI
import CoreData

struct GenreDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isEditingGenre = false
    
    private var genre: Genre
    @State private var name: String
    
    @FetchRequest private var albums: FetchedResults<Album>
    
    init(genre: Genre) {
        self.genre = genre
        self.name = genre.name ?? ""
        
        self._albums = FetchRequest<Album>(
            entity: Album.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Album.title, ascending: true)],
            predicate: NSPredicate(format: "ANY genres == %@", genre)
        )
    }
    
    var body: some View {
        VStack {
            Text(genre.name ?? "")
                .font(.title)
                .fontDesign(.rounded)
            
            if !albums.isEmpty {
                Text("Albums:")
                    .font(.headline)
                
                ForEach(albums) { album in
                    Text(album.title ?? "")
                }
            } else {
                Text("No albums found for this genre.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationBarItems(trailing: Button("Edit") {
            isEditingGenre = true
        })
        .sheet(isPresented: $isEditingGenre) {
            TextFieldAlert(
                isPresented: $isEditingGenre,
                text: $name,
                title: "Edit Genre",
                message: "Enter the new genre name:",
                placeholder: "Genre Name",
                action: saveGenre
            )
        }
    }
    
    private func saveGenre() {
        genre.name = name
        try? viewContext.save()
    }
}

struct TextFieldAlert: View {
    @Binding var isPresented: Bool
    @Binding var text: String
    var title: String
    var message: String
    var placeholder: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Button("Save") {
                    action()
                    isPresented = false
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

//#Preview {
//    GenreDetailView()
//}
