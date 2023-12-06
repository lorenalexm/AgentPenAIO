//
//  GenerationRepositoryTests.swift
//  
//
//  Created by Alex Loren on 12/6/23.
//

@testable import App
import Fluent
import XCTVapor

final class GenerationRepositoryTests: XCTestCase {
    // MARK: - Properties
    var app: Application!
    var repository: GenerationRepository!
    
    // MARK: - Functions
    /// Sets up the testing environment before each test.
    override func setUp() async throws {
        app = try await Application.testable()
        repository = GenerationRepository(database: app.db)
    }
    
    /// Tears down the testing environment before each test.
    override func tearDown() async throws {
        app.shutdown()
    }
    
    /// Attempts creating a `Generation` object and saving it to the `Database`.
    func testCreateGeneration() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        let _ = try await createAndSaveGeneration(app: app, for: listing)
        let count = try await repository.count()
        XCTAssertEqual(count, 1)
    }
    
    /// Attempts to get an array of all the `Generation` objects from the `Database`.
    func testGettingAllGenerations()  async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        for _ in 0...4 {
            let _ = try await createAndSaveGeneration(app: app, for: listing)
        }
        let generations = try await repository.all()
        XCTAssertNotNil(generations)
        XCTAssertEqual(generations.count, 5)
    }
    
    /// Attempts to fetch a specific `Generation` from the `Database`.
    func testFindGeneration() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        let generation = try await createAndSaveGeneration(app: app, for: listing)
        let fetched = try await repository.find(id: generation.id!)
        XCTAssertEqual(generation.id, fetched?.id)
    }
}
