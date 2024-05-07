//
//  GenreSelectionView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/06.
//

import SwiftUI

struct GenreSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Genre.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Genre.name, ascending: true)])
    private var genres: FetchedResults<Genre>
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAddGenreView = false
    
    private var album: Album
    init(album: Album) {
        self.album = album
    }
    
    var body: some View {
        NavigationView {
            List(genres) { genre in
                Button(action: {
                    toggleGenreSelection(genre)
                }) {
                    HStack {
                        Text(genre.name ?? "")
                        Spacer()
                        if isGenreSelected(genre) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationBarTitle("Genres")
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
    
    private func isGenreSelected(_ genre: Genre) -> Bool {
        album.genres?.contains(genre) ?? false
    }
    
    private func toggleGenreSelection(_ genre: Genre) {
        if isGenreSelected(genre) {
            album.removeFromGenres(genre)
        } else {
            album.addToGenres(genre)
        }
        
        try? viewContext.save()
    }
}

//#Preview {
//    GenreSelectionView()
//}
