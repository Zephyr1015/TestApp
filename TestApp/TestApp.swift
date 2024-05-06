//
//  TestAppApp.swift
//  TestApp
//
//  Created by Vincent on 2024/04/23.
//

import SwiftUI
import CoreData

@main
struct TestApp: App {
    let albumDataManager = AlbumDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, albumDataManager.container.viewContext)
        }
    }
}
