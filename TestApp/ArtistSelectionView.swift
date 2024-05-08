//
//  ArtistSelectionView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/08.
//

import SwiftUI

struct ArtistSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Artist.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Artist.name, ascending: true)])
    private var artists: FetchedResults<Artist>
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingAddArtistView = false
    
    private var album: Album
    init(album: Album) {
        self.album = album
    }
    
    var body: some View {
        NavigationView {
            List(artists) { artist in
                Button(action: {
                    toggleArtistSelection(artist)
                }) {
                    HStack {
                        Text(artist.name ?? "")
                        Spacer()
                        if isArtistSelected(artist) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationBarTitle("Artists")
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
    
    private func isArtistSelected(_ artist: Artist) -> Bool {
        album.artists?.contains(artist) ?? false
    }
    
    private func toggleArtistSelection(_ artist: Artist) {
        if isArtistSelected(artist) {
            album.removeFromArtists(artist)
        } else {
            album.addToArtists(artist)
        }
        
        try? viewContext.save()
    }
}

//#Preview {
//    ArtistSelectionView()
//}
