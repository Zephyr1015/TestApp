//
//  GenreListView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/06.
//

import SwiftUI
import CoreData

struct GenreListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Genre.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
        animation: .default
    ) var fetchedGenreList: FetchedResults<Genre>
    
    @State private var isAddingGenre = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedGenreList) { genre in
                    NavigationLink(destination: GenreDetailView(genre: genre)) {
                        VStack(alignment: .leading) {
                            Text(genre.name ?? "")
                        }
                    }
                }
                .onDelete(perform: deleteGenre)
            }
//            .navigationBarTitle("Genres")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingGenre = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingGenre) {
                AddGenreView(isPresented: $isAddingGenre)
            }
        }
    }
    
    private func deleteGenre(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedGenreList[index])
        }
        try? viewContext.save()
    }
}

struct AddGenreView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Genre Details")) {
                    TextField("Name", text: $name)
                }
            }
            .navigationBarTitle("Add Genre")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                addGenre()
            })
        }
    }
    
    private func addGenre() {
        let newGenre = Genre(context: viewContext)
        newGenre.name = name
        
        try? viewContext.save()
        
        isPresented = false
    }
}

#Preview {
    GenreListView()
}
