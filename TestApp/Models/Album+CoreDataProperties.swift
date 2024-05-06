//
//  Album+CoreDataProperties.swift
//  TestApp
//
//  Created by Vincent on 2024/05/04.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var artist: String?
    @NSManaged public var coverImageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var tracks: NSObject?
    @NSManaged public var year: String?
    @NSManaged public var genres: NSSet?

}

// MARK: Generated accessors for genres
extension Album {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: Genre)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: Genre)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}

extension Album : Identifiable {

}
