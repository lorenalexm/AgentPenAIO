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
    
    // MARK: - Functions
    
    /// Creates a `UserDTO` object for returning to a client.
    /// - Parameters:
    ///    - id: A unique identifier for this `User`.
    ///   - email: A unique email for the `User`.
    ///   - fullName: The first and last name of the `User`.
    init(id: UUID? = nil, fullName: String, email: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
    }
    
    /// Creates a `UserDTO` object for returning to a client.
    /// Created from an already existing `User` object.
    /// - Parameter user: The `User` object to create the `UserDTO` from.
    init(from user: User) {
        self.init(id: user.id, fullName: user.fullName, email: user.email)
    }
}
