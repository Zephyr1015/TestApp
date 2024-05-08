//
//  ArtistListView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/07.
//

import SwiftUI
import CoreData

struct ArtistListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Artist.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        animation: .default
    ) var fetchedArtistList: FetchedResults<Artist>
    
    @State private var isAddingArtist = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedArtistList) { artist in
                    NavigationLink(destination: ArtistDetailView(artist: artist)) {
                        VStack(alignment: .leading) {
                            Text(artist.name ?? "")
                        }
                    }
                }
                .onDelete(perform: deleteArtist)
            }
//            .navigationBarTitle("Artists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingArtist = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingArtist) {
                AddArtistView(isPresented: $isAddingArtist)
            }
        }
    }
    
    private func deleteArtist(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedArtistList[index])
        }
        try? viewContext.save()
    }
}

//#Preview {
//    ArtistListView()
//}
