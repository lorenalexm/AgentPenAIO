//
//  CreateUser.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Fluent

struct CreateUser: AsyncMigration {
    // MARK: - Functions
    
    /// Creates the `users` table in the database and sets requirements.
    /// - Parameter database: The database object that the `Application` is using.
    func prepare(on database: Database) async throws {
        return try await database.schema("users")
            .id()
            .field("firebaseId", .string, .required)
            .field("email", .string, .required)
            .field("fullName", .string, .required)
            .field("credits", .int, .required, .sql(.default(0)))
            .field("createdAt", .datetime)
            .field("updatedAt", .datetime)
            .unique(on: "firebaseId")
            .unique(on: "email")
            .create()
    }
    
    /// Deletes the `users` table from the database.
    /// - Parameter database: The database object that the `Application` is using.
    func revert(on database: Database) async throws {
        return try await database.schema("users").delete()
    }
}
