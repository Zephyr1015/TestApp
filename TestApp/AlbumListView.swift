//
//  AlbumListView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/03.
//

import SwiftUI
import CoreData

struct AlbumListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Album.entity(),
        sortDescriptors: [NSSortDescriptor(key: "title", ascending: false)],
        animation: .default
    ) var fetchedAlbumList: FetchedResults<Album>
    
    
    @State private var isAddingAlbum = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedAlbumList) { album in
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        VStack(alignment: .leading) {
                            Text(album.title ?? "")
                                .font(.headline)
                            Text(album.artist ?? "")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteAlbum)
            }
            .navigationBarTitle("Albums")
            .navigationBarItems(trailing: Button(action: {
                isAddingAlbum = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddingAlbum) {
                AddAlbumView(isPresented: $isAddingAlbum)
            }
        }
    }
    
    private func deleteAlbum(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedAlbumList[index])
        }
        try? viewContext.save()
    }
}

struct AddAlbumView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var artist = ""
    @State private var year = ""
    @State private var coverImageURL = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Album Details")) {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                    TextField("Year", text: $year)
                    TextField("Cover Image URL", text: $coverImageURL)
                }
            }
            .navigationBarTitle("Add Album")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                addAlbum()
            })
        }
    }
    
    private func addAlbum() {
        let newAlbum = Album(context: viewContext)
        newAlbum.title = title
        newAlbum.artist = artist
        newAlbum.year = year
        newAlbum.coverImageURL = coverImageURL
        
        try? viewContext.save()
        
        isPresented = false
    }
}

#Preview {
    AlbumListView()
}
