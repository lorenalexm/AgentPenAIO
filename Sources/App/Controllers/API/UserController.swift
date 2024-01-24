//
//  UserController.swift
//
//
//  Created by Alex Loren on 1/5/24.
//

import Vapor
import FirebaseJWTMiddleware

struct UserController: RouteCollection {
    // MARK: - Properties.
    let app: Application
    
    // MARK: - Functions.
    
    /// Groups each request into a collection.
    /// - Parameter routes: The `RoutesBuilder` object provided by the `Application`.
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        let grouped = api.grouped("user")
        grouped.get(use: getUser)
        grouped.get("verify", use: verifyOrCreate)
    }
    
    /// Returns a `UserDTO` of a `User` based on their Firebase user Id.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: A `UserDTO` from the matching `User` object.
    func getUser(req: Request) async throws -> UserDTO {
        let token = try await req.verifyToken()
        if let user = try await app.repositories.users.findWithChildren(firebaseId: token.userID) {
            return user.toDTO()
        }
        
        throw Abort(.notFound, reason: "Unable to find User with Firebase user Id.")
    }
    
    /// Verifies a `User` exists within the `Database` or creates a new `User`.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: An `HTTPResponseStatus` based on either errors, or a found or created `User`.
    func verifyOrCreate(req: Request) async throws -> Response {
        let token = try await req.verifyToken()
        if let user = try await app.repositories.users.find(firebaseId: token.userID) {
            guard let email = token.email else {
                throw Abort(.badRequest, reason: "Firebase user does not have an email.")
            }
            
            guard email == user.email else {
                throw Abort(.badRequest, reason: "Firebase user email does not match local user email.")
            }
            return Response(status: .ok)
        } else {
            guard let email = token.email else {
                throw Abort(.badRequest, reason: "Firebase user does not have an email.")
            }
            
            guard let name = token.name else {
                throw Abort(.badRequest, reason: "Firebase user does not have a name.")
            }
            
            let user = User(firebaseId: token.userID, email: email, fullName: name)
            try await app.repositories.users.create(user)
            return Response(status: .created)
        }
    }
}
