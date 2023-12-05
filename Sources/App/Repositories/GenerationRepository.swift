//
//  GenerationRepository.swift
//
//
//  Created by Alex Loren on 10/22/23.
//

import Vapor
import Fluent

struct GenerationRepository: DatabaseRepository {
    // MARK: - Properties
    let database: Database
    
    // MARK: - Functions
    /// Creates a new `Generation` within the `Database`.
    /// - Parameter property: The `Generation` object to be saved.
    func create(_ generation: Generation) async throws {
        try await generation.create(on: database)
    }
    
    /// Fetches all of the `Generation` objects from the `Database`.
    /// - Returns: An array of `Generation` objects.
    func all() async throws -> [Generation] {
        return try await Generation.query(on: database).all()
    }
    
    /// Finds a `Generation` from the `Database` by its unique identifier.
    /// - Parameter id: The unique identifier of the `Generation`.
    /// - Returns: A single `Listing` object.
    func find(id: UUID) async throws -> Generation? {
        return try await Generation.find(id, on: database)
    }
    
    /// Fetches the total count of `Generation` objects from the `Database`.
    /// - Returns: The `Generation` count.
    func count() async throws -> Int {
        return try await Generation.query(on: database).count()
    }
}
