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
        sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)],
        animation: .default
    ) var fetchedAlbumList: FetchedResults<Album>
    
    @State private var isAddingAlbum = false
    @State private var searchText: String = ""
    
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
//            .navigationBarTitle("Albums")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingAlbum = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        exportAlbums()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $isAddingAlbum) {
                AddAlbumView(isPresented: $isAddingAlbum)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Type to Search")
        .onChange(of: searchText) {
            search(text: $0)
        }
    }
    
    private func deleteAlbum(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedAlbumList[index])
        }
        try? viewContext.save()
    }
    
    private func search(text: String) {
        if text.isEmpty {
            fetchedAlbumList.nsPredicate = nil
        } else {
            let titlePredicate: NSPredicate = NSPredicate(format: "title contains %@", text)
            let artistPredicate: NSPredicate = NSPredicate(format: "artist contains %@", text)
            fetchedAlbumList.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, artistPredicate])
        }
    }
    
    private func exportAlbums() {
        let request = NSFetchRequest<Album>(entityName: "Album")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Album.title, ascending: true)]
        
        do {
            let albums = try viewContext.fetch(request)
            let csvString = convertToCSV(albums: albums)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("albums.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            shareCVS(fileURL: fileURL)
        } catch {
            print("获取专辑数据失败: \(error)")
        }
    }
    
    private func convertToCSV(albums: [Album]) -> String {
        let headerRow = "title,artist,year,genres,createdAt\n"
        
        let rows = albums.map { album in
            let title = album.title ?? ""
            let artist = album.artist ?? ""
            let year = album.year ?? ""
            
            let genres = album.genres?.compactMap { ($0 as? Genre)?.name }.joined(separator: ", ") ?? ""
            
            if let createdAt = album.createdAt {
                let formattedDate = createdAt.formatted(date: .numeric, time: .omitted)
                return "\"\(title)\",\"\(artist)\",\"\(year)\",\"\(genres)\",\"\(formattedDate)\"" // \"\(content)\"
            } else {
                return "\"\(title)\",\"\(artist)\",\"\(year)\",\"\(genres)\",\"\""
            }
        }
        
        return headerRow + rows.joined(separator: "\n")
    }
    
    private func shareCVS(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }
}

#Preview {
    AlbumListView()
}
