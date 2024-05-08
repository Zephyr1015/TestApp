//
//  AddArtistView.swift
//  TestApp
//
//  Created by Vincent on 2024/05/07.
//

import SwiftUI
import CoreData

struct AddArtistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Artist Details")) {
                    TextField("Name", text: $name)
                }
            }
            .navigationBarTitle("Add Artist")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                addArtist()
            })
        }
    }
    
    private func addArtist() {
        let newArtist = Artist(context: viewContext)
        newArtist.name = name
        
        try? viewContext.save()
        
        isPresented = false
    }
}

//#Preview {
//    AddArtistView()
//}
