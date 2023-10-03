//
//  ModelMocks.swift
//
//
//  Created by Alex Loren on 10/3/23.
//

@testable import App
import XCTVapor
import Fakery
import Vapor

/// Helper function to create a `Listing` object already populated.
/// - Parameter owner: The `User` who should own this `Listing`.
/// - Returns: The newly created `Listing` object.
func createListing(owner: User, revisions: Int? = nil) throws -> Listing {
    let faker = Faker()
    
    return Listing(userId: try owner.requireID(),
                   streetAddress: faker.address.streetAddress(),
                   city: faker.address.city(),
                   state: faker.address.stateAbbreviation(),
                   structureType: "Condo",
                   architectureType: "Modern",
                   bedrooms: faker.number.randomInt(),
                   bathrooms: faker.number.randomFloat(),
                   squareFeet: faker.number.randomInt(),
                   acerage: faker.number.randomFloat(),
                   propertyFeatures: "Open Concept",
                   communityAmenities: "Pool",
                   writingStyle: "Happy",
                   characterLimit: faker.number.randomInt(),
                   socialHashtags: faker.number.randomBool(),
                   socialEmoji: faker.number.randomBool(),
                   revisions: revisions ?? faker.number.randomInt())
}

/// Helper function to create a `Listing` object already populated.
/// Saves this `Listing` to the `Database`.
/// - Parameters:
///   - app: The `Application` that contains our `Database` access.
///   - owner: The `User` who should own this `Listing`.
/// - Returns: The newly created `Listing` object.
func createAndSaveListing(app: Application, owner: User) async throws -> Listing {
    let listing = try createListing(owner: owner)
    try await app.repositories.listings.create(listing)
    return listing
}

/// Helper function to create a `User` object already populated.
/// - Returns: The newly created `User` object.
func createUser() -> User {
    let faker = Faker()
    
    return User(email: faker.internet.email(),
                passwordHash: faker.internet.password(minimumLength: 8, maximumLength: 24),
                fullName: faker.name.name())
}

/// Helper function to create a `User` object already populated.
/// Saves this `User` to the `Database` and tests the Id is populated.
/// - Parameter app: The `Application` that contains our `Database` access.
/// - Returns: The newly created `User` object.
func createAndSaveUser(app: Application) async throws -> User {
    let user = createUser()
    try await app.repositories.users.create(user)
    XCTAssertNotNil(user.id)
    return user
}
