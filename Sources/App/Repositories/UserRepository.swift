//
//  UserRepository.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor
import Fluent

struct UserRepository: DatabaseRepository {
    // MARK: - Properties
    let database: Database
    
    // MARK: - Functions
    
    /// Creates a new `User` within the `Database`.
    /// - Parameter user: The `User` object to be saved.
    func create(_ user: User) async throws {
        try await user.create(on: database)
    }
    
    /// Deletes a `User` from the `Database`.
    /// - Parameter id: The unique identifier of the `User`.
    func delete(id: UUID) async throws {
        try await User.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    /// Fetches all of the `User` objects from the `Database`.
    /// - Returns: An array of `User` objects.
    func all() async throws -> [User] {
        return try await User.query(on: database).all()
    }
    
    /// Finds a `User` from the `Database` by their unique identifier.
    /// - Parameter id: The unique identifier of the `User`.
    /// - Returns: A single `User` object.
    func find(id: UUID?) async throws -> User? {
        return try await User.find(id, on: database)
    }
    
    /// Finds a `User` from the `Database` by their unique identifier.
    /// Loads the `Listing` children at the same time.
    /// - Parameter id: The unique identifier of the `User`.
    /// - Returns: A single `User` object.
    func findWithChildren(id: UUID?) async throws -> User? {
        return try await User.query(on: database)
            .filter(\.$id == id!)
            .with(\.$listings)
            .first()
    }
    
    /// Finds a `User` from the `Database` by their email address.
    /// - Parameter email: The email address of the `User`.
    /// - Returns: A single `User` object
    func find(email: String) async throws -> User? {
        return try await User.query(on: database)
            .filter(\.$email == email)
            .first()
    }
    
    /// Finds a `User` from the `Database` by their email address.
    /// Loads the `Listing` children at the same time.
    /// - Parameter email: The email address of the `User`.
    /// - Returns: A single `User` object
    func findWithChildren(email: String) async throws -> User? {
        return try await User.query(on: database)
            .filter(\.$email == email)
            .with(\.$listings)
            .first()
    }
    
    /// Sets the value of a `QueryableProperty` for a given `User`.
    /// - Parameters:
    ///   - field: The `User` field that will be updated.
    ///   - value: The value to set to the field.
    ///   - id: The unique identifier of the `User`.
    func set<Field>(_ field: KeyPath<User, Field>, to value: Field.Value, for id: UUID) async throws where Field: QueryableProperty, Field.Model == User {
        try await User.query(on: database)
            .filter(\.$id == id)
            .set(field, to: value)
            .update()
    }
    
    /// Fetches the total count of `User` objects from the `Database`.
    /// - Returns: The `User` count.
    func count() async throws -> Int {
        return try await User.query(on: database).count()
    }
}
