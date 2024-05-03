//
//  AlbumListView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/03.
//

import SwiftUI
import CoreData

struct AlbumListView: View {
    @StateObject private var albumDataManager = AlbumDataManager.shared
    @State private var isAddingAlbum = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(albumDataManager.albums) { album in
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        VStack(alignment: .leading) {
                            Text(album.title ?? "")
                                .font(.headline)
                            Text(album.artist ?? "")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteAlbums)
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
            .onAppear {
                albumDataManager.albums = albumDataManager.getAllAlbums()
            }
        }
    }
    
    private func deleteAlbums(offsets: IndexSet) {
        offsets.map { albumDataManager.albums[$0] }.forEach(albumDataManager.deleteAlbum)
        albumDataManager.albums = albumDataManager.getAllAlbums()
    }
}

struct AddAlbumView: View {
    @StateObject private var albumDataManager = AlbumDataManager.shared
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
        let newAlbum = Album(context: albumDataManager.persistentContainer.viewContext)
        newAlbum.title = title
        newAlbum.artist = artist
        newAlbum.year = year
        newAlbum.coverImageURL = coverImageURL
        
        albumDataManager.saveAlbum(newAlbum)
        albumDataManager.albums = albumDataManager.getAllAlbums() //
        isPresented = false
    }
}

#Preview {
    AlbumListView()
}
