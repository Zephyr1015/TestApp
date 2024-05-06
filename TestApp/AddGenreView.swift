//
//  AddGenreView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/06.
//

import SwiftUI

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

//#Preview {
//    AddGenreView()
//}
