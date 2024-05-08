//
//  ContentView.swift
//  TestApp
//
//  Created by Vincent on 2024/04/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selectedView = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select View", selection: $selectedView) {
                    Text("Albums").tag(0)
                    Text("Genres").tag(1)
                    Text("Artists").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                switch selectedView {
                case 0:
                    AlbumListView()
                case 1:
                    GenreListView()
                case 2:
                    ArtistListView()
                default:
                    AlbumListView()
                }
            }
            .navigationBarTitle("Music Library")
        }
    }
}

#Preview {
    ContentView()
}
