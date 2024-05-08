//
//  Artist+CoreDataProperties.swift
//  TestApp
//
//  Created by Vincent on 2024/05/07.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var name: String?
    @NSManaged public var albums: NSSet?

}

// MARK: Generated accessors for albums
extension Artist {

    @objc(addAlbumsObject:)
    @NSManaged public func addToAlbums(_ value: Album)

    @objc(removeAlbumsObject:)
    @NSManaged public func removeFromAlbums(_ value: Album)

    @objc(addAlbums:)
    @NSManaged public func addToAlbums(_ values: NSSet)

    @objc(removeAlbums:)
    @NSManaged public func removeFromAlbums(_ values: NSSet)

}

extension Artist : Identifiable {

}
