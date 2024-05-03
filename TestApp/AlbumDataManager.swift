//
//  AlbumDataManager.swift
//  TestApp
//
//  Created by Vincent on 2024/04/30.
//

import Foundation
import CoreData

class AlbumDataManager: ObservableObject {
    static let shared = AlbumDataManager()
    let persistentContainer: NSPersistentContainer
    
    @Published var albums: [Album] = []
    
    init() {
        persistentContainer = NSPersistentContainer(name: "AlbumModel")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        albums = getAllAlbums()
    }
    
    func saveAlbum(_ album: Album) {
        let context = persistentContainer.viewContext
        context.perform {
            context.insert(album)
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAlbum(_ album: Album) {
        let context = persistentContainer.viewContext
        context.perform {
            context.delete(album)
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAllAlbums() -> [Album] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveGenre(_ genre: Genre) {
        let context = persistentContainer.viewContext
        context.perform {
            context.insert(genre)
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteGenre(_ genre: Genre) {
        let context = persistentContainer.viewContext
        context.perform {
            context.delete(genre)
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAllGenres() -> [Genre] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

