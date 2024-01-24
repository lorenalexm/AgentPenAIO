//
//  ListingRepository.swift
//
//
//  Created by Alex Loren on 10/3/23.
//

import Vapor
import Fluent

struct ListingRepository: DatabaseRepository {
    // MARK: - Properties
    let database: Database
    
    // MARK: - Functions
    
    /// Creates a new `Listing` within the `Database`.
    /// - Parameter property: The `Listing` object to be saved.
    func create(_ listing: Listing) async throws {
        try await listing.create(on: database)
    }
    
    /// Deletes a `Listing` from the `Database`.
    /// - Parameter id: The unique identifier of the `Listing`.
    func delete(id: UUID) async throws {
        try await Listing.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    /// Updates a `Listing` from the `Database` from a source `Listing` object.
    /// - Parameters:
    ///   - id: The unique identifier of the `Listing`.
    ///   - source: The new source of data for a `Listing` object.
    func update(id: UUID, with source: Listing) async throws {
        try await Listing.query(on: database)
            .filter(\.$id == id)
            .set(\.$streetAddress, to: source.streetAddress)
            .set(\.$city, to: source.city)
            .set(\.$state, to: source.state)
            .set(\.$structureType, to: source.structureType)
            .set(\.$architectureType, to: source.architectureType)
            .set(\.$bedrooms, to: source.bedrooms)
            .set(\.$bathrooms, to: source.bathrooms)
            .set(\.$squareFeet, to: source.squareFeet)
            .set(\.$acerage, to: source.acerage)
            .set(\.$propertyFeatures, to: source.propertyFeatures)
            .set(\.$communityAmenities, to: source.communityAmenities)
            .set(\.$writingStyle, to: source.writingStyle)
            .set(\.$characterLimit, to: source.characterLimit)
            .set(\.$socialHashtags, to: source.socialHashtags)
            .set(\.$socialEmoji, to: source.socialEmoji)
            .set(\.$revisions, to: source.revisions)
            .update()
    }
    
    /// Fetches all of the `Listing` objects from the `Database`.
    /// - Returns: An array of `Listing` objects.
    func all() async throws -> [Listing] {
        return try await Listing.query(on: database).all()
    }
    
    /// Finds a `Listing` from the `Database` by its unique identifier.
    /// - Parameter id: The unique identifier of the `Listing`.
    /// - Returns: A single `Listing` object.
    func find(id: UUID) async throws -> Listing? {
        return try await Listing.find(id, on: database)
    }
    
    /// Finds a `Listing` from the `Database` by its unique identifier.
    /// Loads `Generation` children at the same time.
    /// - Parameter id: The unique identifier of the `Listing`.
    /// - Returns: A single `Listing` object.
    func findWithChildren(id: UUID) async throws -> Listing? {
        return try await Listing.query(on: database)
            .filter(\.$id == id)
            .with(\.$generations)
            .first()
    }
    
    /// Sets the value of a `QueryableProperty` for a given `Listing`.
    /// - Parameters:
    ///   - field: The `Property` field that will be updated.
    ///   - value: The value to set to the field.
    ///   - id: The unique identifier of the `Listing`.
    func set<Field>(_ field: KeyPath<Listing, Field>, to value: Field.Value, for id: UUID) async throws where Field: QueryableProperty, Field.Model == Listing {
        try await Listing.query(on: database)
            .filter(\.$id == id)
            .set(field, to: value)
            .update()
    }
    
    /// Fetches the total count of `Listing` objects from the `Database`.
    /// - Returns: The `Listing` count.
    func count() async throws -> Int {
        return try await Listing.query(on: database).count()
    }
}
