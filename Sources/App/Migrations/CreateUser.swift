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
            .field("email", .string, .required)
            .field("passwordHash", .string, .required)
            .field("fullName", .string, .required)
            .field("isEmailVerified", .bool, .required, .custom("DEFAULT FALSE"))
            .field("createdAt", .datetime)
            .field("updatedAt", .datetime)
            .unique(on: "email")
            .create()
    }
    
    /// Deletes the `users` table from the database.
    /// - Parameter database: The database object that the `Application` is using.
    func revert(on database: Database) async throws {
        return try await database.schema("users").delete()
    }
}
