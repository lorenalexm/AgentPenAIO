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
    var firebaseResponse: FirebaseLoginResponse?
    var token: String?
    
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
    
    /// Attempts to perform a login with Firebase.
    /// - Returns: A response from the Firebase Auth server.
    func getFirebaseLoginResponse() async throws -> FirebaseLoginResponse {
        guard let firebaseResponse else {
            firebaseResponse = try await performFirebaseLogin()
            return firebaseResponse!
        }
        
        return firebaseResponse
    }
    
    /// Attempts to get a new token, or return the cached token.
    /// - Returns: A Firebase user Id token.
    func getToken() async throws -> String {
        guard let token else {
            token = try await getFirebaseLoginResponse().idToken
            return token!
        }
        
        return token
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
    
    /// Attempts creating a `Listing` object and saving it to the `Database` under a `User`.
    func testCreatingListingForUser() async throws {
        try await app.repositories.users.create(User(firebaseId: getToken(), email: "fake@user.email", fullName: "Dummy User"))
        let user = try await app.repositories.users.find(firebaseId: getToken())!
        let listing = try createListing(owner: user)
        try await repository.create(listing, forOwner: user)
        let count = try await repository.count()
        XCTAssertEqual(count, 1)
        
        let fetched = try await repository.find(id: listing.id!, ownedBy: getToken())
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
        for _ in 0...2 {
            let _ = try await createAndSaveListing(app: app, owner: user)
        }
        let listings = try await repository.all()
        XCTAssertEqual(listings.count, 3)
    }
    
    /// Attempts to get an array of all the `Listing` objects from the `Database` owned by a specific Firebase Id.
    func testGettingAllListingsWithFirebase() async throws {
        var user = try await createAndSaveUser(app: app)
        for _ in 0...3 {
            let _ = try await createAndSaveListing(app: app, owner: user)
        }
        
        try await app.repositories.users.create(User(firebaseId: getToken(), email: "fake@user.email", fullName: "Dummy User"))
        user = try await app.repositories.users.find(firebaseId: getToken())!
        for _ in 0...3 {
            let _ = try await createAndSaveListing(app: app, owner: user)
        }
        let listing = try await createAndSaveListing(app: app, owner: user)
        let count = try await repository.count()
        XCTAssertEqual(9, count)
        
        let listings = try await repository.all(ownedBy: getToken())
        XCTAssertNotNil(listings)
        XCTAssertEqual(5, listings.count)
        XCTAssertEqual(listings[4].id, listing.id)
    }
    
    /// Attempts to fetch a specific `Listing` object by `UUID` from the `Database`.
    func testFindListingById() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        let fetched = try await repository.find(id: listing.id!)
        XCTAssertEqual(listing.id, fetched?.id)
    }
    
    /// Attempts to fetch a specific `Listing` object by `UUID` from the `Database` owned by a specific Firebase Id.
    func testFindListingByIdWithFirebase() async throws {
        var user = try await createAndSaveUser(app: app)
        for _ in 0...3 {
            let _ = try await createAndSaveListing(app: app, owner: user)
        }
        
        try await app.repositories.users.create(User(firebaseId: getToken(), email: "fake@user.email", fullName: "Dummy User"))
        user = try await app.repositories.users.find(firebaseId: getToken())!
        let listing = try await createAndSaveListing(app: app, owner: user)
        let count = try await repository.count()
        XCTAssertEqual(5, count)
        
        let fetched = try await repository.find(id: listing.id!, ownedBy: getToken())
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, listing.id)
    }
    
    /// Attempts to fetch a specific `Listing` object by `UUID` from the `Database` owned by a specific Firebase Id.
    /// Should fail as `User` does not have any listings.
    func testFailToFindListingByIdWithFirebase() async throws {
        var user = try await createAndSaveUser(app: app)
        for _ in 0...3 {
            let _ = try await createAndSaveListing(app: app, owner: user)
        }
        let listing = try await createAndSaveListing(app: app, owner: user)
        
        try await app.repositories.users.create(User(firebaseId: getToken(), email: "fake@user.email", fullName: "Dummy User"))
        user = try await app.repositories.users.find(firebaseId: getToken())!
        let count = try await repository.count()
        XCTAssertEqual(5, count)
        
        let fetched = try await repository.find(id: listing.id!, ownedBy: getToken())
        XCTAssertNil(fetched)
    }
    
    /// Attempts to fetch a specific `Listing` and its `Generation` objects by `UUID` from the `Database`.
    func testFindListingByIdWithChildren() async throws {
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        for _ in 0...2 {
            let _ = try await createAndSaveGeneration(app: app, for: listing)
        }
        let fetched = try await repository.findWithChildren(id: listing.id!)
        XCTAssertEqual(listing.id, fetched?.id)
        XCTAssertEqual(fetched?.generations.count, 3)
    }
    
    /// Attempts to fetch a specific `Listing` and its `Generation` objects by `UUID` from the `Database` owned by a specific Firebase Id.
    func testFindListingByIdWithChildrenWithFirebase() async throws {
        try await app.repositories.users.create(User(firebaseId: getToken(), email: "fake@user.email", fullName: "Dummy User"))
        let user = try await app.repositories.users.find(firebaseId: getToken())!
        let listing = try await createAndSaveListing(app: app, owner: user)
        for _ in 0...2 {
            let _ = try await createAndSaveGeneration(app: app, for: listing)
        }
        let fetched = try await repository.findWithChildren(id: listing.id!, ownedBy: getToken())
        XCTAssertEqual(listing.id, fetched?.id)
        XCTAssertEqual(fetched?.generations.count, 3)
    }
    
    /// Attempts to fetch a specific `Listing` and its `Generation` objects by `UUID` from the `Database` owned by a specific Firebase Id.
    /// Should fail as `User` does not have any listings.
    func testFailToFindListingByIdWithChildrenWithFirebase() async throws {
        try await app.repositories.users.create(User(firebaseId: getToken(), email: "fake@user.email", fullName: "Dummy User"))
        let _ = try await app.repositories.users.find(firebaseId: getToken())!
        let user = try await createAndSaveUser(app: app)
        let listing = try await createAndSaveListing(app: app, owner: user)
        for _ in 0...2 {
            let _ = try await createAndSaveGeneration(app: app, for: listing)
        }
        let fetched = try await repository.findWithChildren(id: listing.id!, ownedBy: getToken())
        XCTAssertNil(fetched)
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
