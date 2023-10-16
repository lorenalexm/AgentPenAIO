//
//  UserRepositoryTests.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

@testable import App
import Fluent
import XCTVapor

final class UserRepositoryTests: XCTestCase {
    // MARK: - Properties
    var app: Application!
    var repository: UserRepository!
    
    // MARK: - Functions
    
    /// Sets up the testing environment before each test.
    override func setUp() async throws {
        app = try await Application.testable()
        repository = UserRepository(database: app.db)
    }
    
    /// Tears down the testing environment before each test.
    override func tearDown() async throws {
        app.shutdown()
    }
    
    /// Attempts creating a `User` object and saving it to the `Database`.
    func testCreatingUser() async throws {
        let user = try await createAndSaveUser(app: app)
        let count = try await repository.count()
        XCTAssertEqual(count, 1)
        
        let fetched = try await User.find(user.id, on: app.db)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(user.id, fetched?.id)
    }
    
    /// Attempts to create two `User` objects with the same email address.
    func testCreatingUserWithDuplicateEmail() async throws {
        let user = User(email: "test@test.com", passwordHash: "123", fullName: "Test User")
        let user2 = User(email: "test@test.com", passwordHash: "123", fullName: "Test User")
        try await repository.create(user)
        await assertThrowsAsyncError(try await repository.create(user2)) { error in
            XCTAssertEqual(error.localizedDescription, "constraint: UNIQUE constraint failed: users.email")
        }
        
        let count = try await repository.count()
        XCTAssertEqual(count, 1)
    }
    
    /// Attempts deleting a newly created `User` object from the `Database`.
    func testDeletingUser() async throws {
        let user = try await createAndSaveUser(app: app)
        var count = try await repository.count()
        XCTAssertEqual(count, 1)
        
        try await repository.delete(id: user.id!)
        count = try await repository.count()
        XCTAssertEqual(count, 0)
    }
    
    /// Attempts to get an array of all the `User` objects from the `Database`.
    func testGettingAllUsers() async throws {
        let _ = try await createAndSaveUser(app: app)
        let _ = try await createAndSaveUser(app: app)
        let users = try await repository.all()
        XCTAssertEqual(users.count, 2)
    }
    
    /// Attempts to fetch a specific `User` object by `UUID` from the `Database`.
    func testFindUserById() async throws {
        let user = try await createAndSaveUser(app: app)
        let fetched = try await repository.find(id: user.id!)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, user.id)
    }
    
    /// Attempts to fetch a specific `User` and their `Listing` objects by `UUID` from the `Database`.
    func testFindUserByIdWithChildren() async throws {
        let user = try await createAndSaveUser(app: app)
        let _ = try await createAndSaveListing(app: app, owner: user)
        let _ = try await createAndSaveListing(app: app, owner: user)
        
        let fetched = try await repository.findWithChildren(id: user.id!)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, user.id)
        XCTAssertNotNil(fetched?.listings)
        XCTAssertEqual(fetched?.listings.count, 2)
    }
    
    /// Attempts to fetch a specific `User` object by email address from the `Database`.
    func testFindUserByEmail() async throws {
        let user = try await createAndSaveUser(app: app)
        let fetched = try await repository.find(email: user.email)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, user.id)
    }
    
    /// Attempts to fetch a specific `User` and their `Listing` objects by email address from the `Database`.
    func testFindUserByEmailWithChildren() async throws {
        let user = try await createAndSaveUser(app: app)
        let _ = try await createAndSaveListing(app: app, owner: user)
        let _ = try await createAndSaveListing(app: app, owner: user)
        
        let fetched = try await repository.findWithChildren(email: user.email)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, user.id)
        XCTAssertNotNil(fetched?.listings)
        XCTAssertEqual(fetched?.listings.count, 2)
    }
    
    /// Attempts to update a `User` field on the `Database`.
    func testSetFieldValue() async throws {
        let user = try await createAndSaveUser(app: app)
        var fetched = try await repository.find(id: user.id!)
        XCTAssertEqual(fetched?.isEmailVerified, false)
        
        try await repository.set(\.$isEmailVerified, to: true, for: fetched!.id!)
        fetched = try await repository.find(id: user.id!)
        XCTAssertEqual(fetched?.isEmailVerified, true)
    }
    
    /// Attempts to load `Listing` children from a `User` parent.
    func testAddingListingsToUser() async throws {
        let user = try await createAndSaveUser(app: app)
        let _ = try await createAndSaveListing(app: app, owner: user)
        let _ = try await createAndSaveListing(app: app, owner: user)
        
        let fetched = try await repository.find(email: user.email)
        XCTAssertNotNil(fetched)
        
        let listings = try await user.$listings.get(on: repository.database)
        XCTAssertNotNil(listings)
        XCTAssertEqual(listings.count, 2)
    }
}
