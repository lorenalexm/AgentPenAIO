//
//  User.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor
import Fluent

final class User: Model, Authenticatable {
    // MARK: - Properties
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "passwordHash")
    var passwordHash: String
    
    @Field(key: "fullName")
    var fullName: String
    
    @Field(key: "isEmailVerified")
    var isEmailVerified: Bool
    
    // MARK: - Functions
    init() { }
    
    /// Creates a `User` object.
    /// - Parameters:
    ///   - id: A unique identifier for this `User`.
    ///   - email: A unique email for the `User`.
    ///   - passwordHash: The `User` password after being hashed.
    ///   - fullName: The first and last name of the `User`.
    ///   - isEmailVerified: Flags the email as being verified or not. Defaults to `false`.
    init(id: UUID? = nil, email: String, passwordHash: String, fullName: String, isEmailVerified: Bool = false) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.fullName = fullName
        self.isEmailVerified = isEmailVerified
    }
}
