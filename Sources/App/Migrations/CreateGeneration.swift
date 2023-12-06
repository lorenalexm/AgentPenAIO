//
//  CreateGeneration.swift
//
//
//  Created by Alex Loren on 10/22/23.
//

import Fluent

struct CreateGeneration: AsyncMigration {
    // MARK: - Functions
    
    /// Creates the `Generation` table in the database and sets requirements.
    /// - Parameter database: The database object that the `Application` is using.
    func prepare(on database: Database) async throws {
        let type = try await database.enum("type")
            .case("intro")
            .case("socialMedia")
            .case("description")
            .create()
        
        
        return try await database.schema("generations")
            .id()
            .field("listingId", .uuid, .required)
            .field("type", type, .required)
            .field("generated", .string, .required)
            .field("createdAt", .datetime)
            .field("updatedAt", .datetime)
            .create()
    }
    
    /// Deletes the `Generation` table from the database.
    /// - Parameter database: The database object that the `Application` is using.
    func revert(on database: Database) async throws {
        return try await database.schema("generations").delete()
    }
}
