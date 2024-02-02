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

/// Helper function to create a `User` object already populated.
/// - Returns: The newly created `User` object.
func createUser() -> User {
    let faker = Faker()
    
    return User(firebaseId: UUID().uuidString,
                email: faker.internet.email(),
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

/// Helper function to create a `Listing` object already populated.
/// - Parameter owner: The `User` who should own this `Listing`.
/// - Parameter revisions: An optional value to give to the revisions property.
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
    try await owner.$listings.create(listing, on: app.repositories.users.database)
    return listing
}

/// Helper function to create a `Listing` object already populated.
/// Saves this `Listing` to the `Database`.
/// - Parameters:
///   - app: The `Application` that contains our `Database` access.
///   - owner: The `User` who should own this `Listing`.
///   - revisions: An optional value to give to the revisions property.
/// - Returns: The newly created `Listing` object.
func createAndSaveListing(app: Application, owner: User, revisions: Int) async throws -> Listing {
    let listing = try createListing(owner: owner, revisions: revisions)
    try await owner.$listings.create(listing, on: app.repositories.users.database)
    return listing
}

/// Helper function to create a `Generation` object already populated.
/// - Parameter listing: The `Listing` that the `Generation` belongs to.
/// - Returns: The newly created `Generation` object.
func createGeneration(for listing: Listing) throws -> Generation {
    return Generation(listing: try listing.requireID(), type: .description, generated: "Hello, World!")
}

/// Helper function to create a `Generation` object already populated.
/// Saves this `Generation` to the `Database`.
/// - Parameters:
///   - listing: The `Listing` that the `Generation` belongs to.
///   - app: The `Application` that contains our `Database` access.
/// - Returns: The newly created `Generation` object.
func createAndSaveGeneration(app: Application, for listing: Listing) async throws -> Generation {
    let generation = try createGeneration(for: listing)
    try await listing.$generations.create(generation, on: app.repositories.generations.database)
    return generation
}
