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
    
    return User(email: faker.internet.email(),
                passwordHash: faker.internet.password(minimumLength: 8, maximumLength: 24),
                fullName: faker.name.name())
}

/// Helper function to create a `User` object already populated.
/// Saves this `User` to the database and tests the Id is populated.
/// - Returns: The newly created `User` object.
func createAndSaveUser(app: Application) async throws -> User {
    let user = createUser()
    try await app.repositories.users.create(user)
    XCTAssertNotNil(user.id)
    return user
}
