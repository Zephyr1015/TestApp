//
//  Album+CoreDataProperties.swift
//  TestApp
//
//  Created by Vincent on 2024/05/07.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var coverImageURL: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var tracks: NSObject?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var year: String?
    @NSManaged public var genres: NSSet?
    @NSManaged public var artists: NSSet?

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

// MARK: Generated accessors for artists
extension Album {

    @objc(addArtistsObject:)
    @NSManaged public func addToArtists(_ value: Artist)

    @objc(removeArtistsObject:)
    @NSManaged public func removeFromArtists(_ value: Artist)

    @objc(addArtists:)
    @NSManaged public func addToArtists(_ values: NSSet)

    @objc(removeArtists:)
    @NSManaged public func removeFromArtists(_ values: NSSet)

}

extension Album : Identifiable {

}
