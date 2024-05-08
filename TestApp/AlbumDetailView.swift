//
//  AlbumDetailView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/03.
//

import SwiftUI
import CoreData

struct AlbumDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isEditingAlbum = false
    @State private var showGenreList = false
    
    @ObservedObject private var album: Album
    @State private var title: String
    @State private var year: String
    @State private var coverImageURL: String
    
    init(album: Album) {
        self.album = album
        self.title = album.title ?? ""
        self.coverImageURL = album.coverImageURL ?? ""
        self.year = album.year ?? ""
    }
    
    var body: some View {
        VStack {
            if let coverImageURL = album.coverImageURL, let url = URL(string: coverImageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            Text(album.title ?? "")
                .font(.title)
            if let artists = album.artists as? Set<Artist> {
                ForEach(artists.sorted(by: { $0.name ?? "" < $1.name ?? "" })) { artist in
                    Text(artist.name ?? "")
                        .font(.subheadline)
                }
            }
            Text(album.year ?? "")
                .font(.subheadline)
            if let genres = album.genres as? Set<Genre> {
                Text("Genres:")
                    .font(.headline)
                
                ForEach(genres.sorted(by: { $0.name ?? "" < $1.name ?? "" })) { genre in
                    Text(genre.name ?? "")
                }
            }
            Button("Add Genre") {
                showGenreList = true
            }
        }
        .navigationBarItems(trailing: Button("Edit") {
            isEditingAlbum = true
        })
        .sheet(isPresented: $isEditingAlbum) {
            EditAlbumView(album: album)
        }
        .sheet(isPresented: $showGenreList) {
            GenreSelectionView(album: album)
        }
    }
}

//#Preview {
//    AlbumDetailView()
//}
