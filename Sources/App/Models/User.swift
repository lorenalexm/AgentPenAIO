//
//  User.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor
import Fluent

final class User: Model {
    // MARK: - Properties
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "firebaseId")
    var firebaseId: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "fullName")
    var fullName: String
    
    @Field(key: "credits")
    var credits: Int
    
    @Children(for: \.$user)
    var listings: [Listing]
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    // MARK: - Functions
    init() { }
    
    /// Creates a `User` object.
    /// - Parameters:
    ///   - id: A unique identifier for this `User`.
    ///   - firebaseId: A unique identifier provided by Firebase for this `User`.
    ///   - email: A unique email for the `User`.
    ///   - fullName: The first and last name of the `User`.
    init(id: UUID? = nil, firebaseId: String, email: String, fullName: String, credits: Int = 0) {
        self.id = id
        self.firebaseId = firebaseId
        self.email = email
        self.fullName = fullName
        self.credits = credits
    }
}
