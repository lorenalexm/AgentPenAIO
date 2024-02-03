//
//  ListingControllerTests.swift
//
//
//  Created by Alex Loren on 2/2/24.
//

@testable import App
import XCTVapor

final class ListingControllerTests: XCTestCase {
    // MARK: - Properties
    var app: Application!
    var listing: Listing?
    var firebaseResponse: FirebaseLoginResponse?
    var token: String?
    
    // MARK: - Functions

    /// Sets up the testing environment before each test.
    override func setUp() async throws {
        app = try await Application.testable()
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
    
    /// Creates a `User` within the `Database`.
    /// - Returns: The newly created `User` object.
    func createUser() async throws -> User {
        let userId = try await getFirebaseLoginResponse().localID
        try await app.repositories.users.create(User(firebaseId: userId, email: "fake@user.email", fullName: "Dummy User"))
        return try await app.repositories.users.find(firebaseId: userId)!
    }
    
    /// Creates a `Listing` and associated `User` object within the `Database`.
    func createListing() async throws {
        let user = try await createUser()
        listing = try await createAndSaveListing(app: app, owner: user)
    }
    
    
    /// Creates a number of `Listing` objects and associated `User` object within the `Database`.
    /// - Parameter count: An optional number of `Listing` objects to create.
    func createListings(count: Int = 4) async throws {
        let user = try await createUser()
        for _ in 0..<count {
            let _ = try await createAndSaveListing(app: app, owner: user)
        }
    }
    
    /// Tests getting a `Listing` without a valid UUID parameter.
    func testGettingListingWithInvalidParameter() async throws {
        try await app.test(.GET, "/api/listing/123", beforeRequest: { request in
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    /// Tests getting a `Listing` without a Bearer token.
    func testGettingListingWithoutToken() async throws {
        try await createListing()
        try app.test(.GET, "/api/listing/\(listing!.requireID().uuidString)", afterResponse: { response in
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    /// Tests getting a `Listing` object.
    func testGettingListing() async throws {
        try await createListing()
        let id = listing!.id!.uuidString
        
        try await app.test(.GET, "/api/listing/\(id)", beforeRequest: { request in
            request.headers.bearerAuthorization = try await BearerAuthorization(token: getToken())
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
        })
        
    }
}
