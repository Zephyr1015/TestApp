//
//  AlbumDetailView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/03.
//

import SwiftUI
import CoreData

struct AlbumDetailView: View {
    @StateObject var album: Album
    @State private var isEditingAlbum = false
    
//    var yearFormatter: NumberFormatter {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        return formatter
//    }
    
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
            
            Text(album.artist ?? "")
                .font(.subheadline)
            
            Text(album.year ?? "")
                .font(.subheadline)
        }
        .navigationBarItems(trailing: Button("Edit") {
            isEditingAlbum = true
        })
        .sheet(isPresented: $isEditingAlbum) {
            EditAlbumView(album: album)
//            EditAlbumView()
        }
    }
}

struct EditAlbumView: View {
    @StateObject private var albumDataManager = AlbumDataManager.shared
    @ObservedObject var album: Album
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Album Details")) {
                    TextField("Title", text: Binding(
                        get: { album.title ?? "" },
                        set: { album.title = $0.isEmpty ? nil : $0 }
                    ))
                    TextField("Artist", text: Binding(
                        get: { album.artist ?? "" },
                        set: { album.artist = $0.isEmpty ? nil : $0 }
                    ))
                    TextField("Year", text: Binding(
                        get: { album.year ?? "" },
                        set: { album.year = $0.isEmpty ? nil : $0 }
                    ))
                    TextField("Cover Image URL", text: Binding(
                        get: { album.coverImageURL ?? "" },
                        set: { album.coverImageURL = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
            .navigationBarTitle("Edit Album")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                albumDataManager.saveAlbum(album)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

//#Preview {
//    AlbumDetailView()
//}

//struct AlbumDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewContext = PersistenceController.preview.container.viewContext
//        let sampleAlbum = Album(context: viewContext)
//        sampleAlbum.title = "Sample Album"
//        sampleAlbum.artist = "Sample Artist"
//        sampleAlbum.year = 2023
//        sampleAlbum.coverImageURL = "https://example.com/sample-cover.jpg"
//        
//        return AlbumDetailView(album: sampleAlbum)
//    }
//}
