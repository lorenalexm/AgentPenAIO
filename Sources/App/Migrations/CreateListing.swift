//
//  CreateListing.swift
//
//
//  Created by Alex Loren on 10/3/23.
//

import Fluent

struct CreateListing: AsyncMigration {
    // MARK: - Functions
    
    /// Creates the `Listing` table in the database and sets requirements.
    /// - Parameter database: The database object that the `Application` is using.
    func prepare(on database: Database) async throws {
        return try await database.schema("listings")
            .id()
            .field("userId", .uuid, .required)
            .field("streetAddress", .string)
            .field("city", .string)
            .field("state", .string)
            .field("structureType", .string)
            .field("architectureType", .string)
            .field("bedrooms", .int)
            .field("bathrooms", .float)
            .field("squareFeet", .int)
            .field("acerage", .float)
            .field("propertyFeatures", .string)
            .field("communityAmenities", .string)
            .field("writingStyle", .string)
            .field("characterLimit", .int)
            .field("socialHashtags", .bool)
            .field("socialEmoji", .bool)
            .field("revisions", .int)
            .field("createdAt", .datetime)
            .field("updatedAt", .datetime)
            .create()
    }
    
    /// Deletes the `Listing` table from the database.
    /// - Parameter database: The database object that the `Application` is using.
    func revert(on database: Database) async throws {
        return try await database.schema("listings").delete()
    }
}
