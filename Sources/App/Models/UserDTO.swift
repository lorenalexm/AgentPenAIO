//
//  UserDTO.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor

struct UserDTO: Content {
    // MARK: - Properties
    let id: UUID?
    let fullName: String
    let email: String
    var credits: Int
    var listings: [Listing]
    
    // MARK: - Functions
    
    /// Creates a `UserDTO` object for returning to a client.
    /// - Parameters:
    ///   - id: A unique identifier for this `User`.
    ///   - email: A unique email for the `User`.
    ///   - fullName: The first and last name of the `User`.
    ///   - credits: The total amount of credits the `User` has purchased.
    ///   - listings: An array of `Listing` objects belonging to the `User`.
    init(id: UUID? = nil, fullName: String, email: String, credits: Int, listings: [Listing]) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.credits = credits
        self.listings = listings
    }
    
    /// Creates a `UserDTO` object for returning to a client.
    /// Created from an already existing `User` object.
    /// - Parameter user: The `User` object to create the `UserDTO` from.
    init(from user: User) {
        self.init(id: user.id, fullName: user.fullName, email: user.email, credits: user.credits, listings: user.$listings.wrappedValue)
    }
}
