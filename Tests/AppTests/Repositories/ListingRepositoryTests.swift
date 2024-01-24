//
//  ListingRepositoryTests.swift
//
//
//  Created by Alex Loren on 10/3/23.
//

@testable import App
import Fluent
import XCTVapor

final class ListingRepositoryTests: XCTestCase {
    // MARK: - Properties
    var app: Application!
    var repository: ListingRepository!
    
    // MARK: - Functions
    
    /// Sets up the testing environment before each test.
    override func setUp() async throws {
        app = try await Application.testable()
        repository = ListingRepository(database: app.db)
    }
    
    /// Tears down the testing environment before each test.
    override func tearDown() async throws {
        app.shutdown()
    }
    
    /// Attempts creating a `Listing` object and saving it to the `Database`.
    func testCreatingListing() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        let count = try await repository.count()
        XCTAssertEqual(count, 1)
        
        let fetched = try await repository.find(id: listing.id!)
        XCTAssertEqual(fetched?.city, listing.city)
        XCTAssertEqual(fetched?.$user.id, user.id)
    }
    
    /// Attempts to delete a newly created `Listing` from the `Database`.
    func testDeletingListing() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        var count = try await repository.count()
        XCTAssertEqual(count, 1)
        
        try await repository.delete(id: listing.id!)
        count = try await repository.count()
        XCTAssertEqual(count, 0)
    }
    
    /// Attempts to get an array of all the `Listing` objects from the `Database`.
    func testGettingAllListings() async throws {
        let user = try await createAndSaveUser(app: app)
        let _ = try await createAndSaveListing(app: app, owner: user)
        let _ = try await createAndSaveListing(app: app, owner: user)
        let listings = try await repository.all()
        XCTAssertEqual(listings.count, 2)
    }
    
    /// Attempts to fetch a specific `Listing` object by `UUID` from the `Database`.
    func testFindListingById() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        let fetched = try await repository.find(id: listing.id!)
        XCTAssertEqual(listing.id, fetched?.id)
    }
    
    /// Attempts to fetch a specific `Listing` and its `Generation` objects by `UUID` from the `Database`.
    func testFindListingByIdWithChildren() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        let _ = try await createAndSaveGeneration(app: app, for: listing)
        let _ = try await createAndSaveGeneration(app: app, for: listing)
        let _ = try await createAndSaveGeneration(app: app, for: listing)
        let fetched = try await repository.findWithChildren(id: listing.id!)
        XCTAssertEqual(listing.id, fetched?.id)
        XCTAssertEqual(fetched?.generations.count, 3)
    }
    
    /// Attempts to update a `User` field on the `Database`.
    func testSetFieldValue() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try createListing(owner: user, revisions: 0)
        try await repository.create(listing)
        XCTAssertEqual(listing.revisions, 0)
        
        try await repository.set(\.$revisions, to: 9, for: listing.id!)
        let fetched = try await repository.find(id: listing.id!)
        XCTAssertEqual(fetched?.revisions, 9)
    }
    
    /// Attempts to update a `User` object on the `Database` with completely new data.
    func testUpdateListing() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        var fetched = try await repository.find(id: listing.id!)
        XCTAssertEqual(listing.streetAddress, fetched?.streetAddress)
        
        let newListingData = try createListing(owner: user)
        try await repository.update(id: listing.id!, with: newListingData)
        XCTAssertNotEqual(fetched?.streetAddress, newListingData.streetAddress)
        
        fetched = try await repository.find(id: listing.id!)
        XCTAssertEqual(fetched?.streetAddress, newListingData.streetAddress)
    }
}
