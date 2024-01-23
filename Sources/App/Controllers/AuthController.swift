//
//  AuthController.swift
//
//
//  Created by Alex Loren on 1/5/24.
//

import Vapor
import FirebaseJWTMiddleware

struct AuthController: RouteCollection {
    // MARK: - Properties.
    let app: Application
    
    // MARK: - Functions.
    
    /// Groups each request into a collection.
    /// - Parameter routes: The `RoutesBuilder` object provided by the `Application`.
    func boot(routes: RoutesBuilder) throws {
        routes.get("verify", use: verifyOrCreate)
    }
    
    /// Verifies a `User` exists within the `Database` or creates a new `User`.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: A redirect to the profile page of the `User`.
    func verifyOrCreate(req: Request) async throws -> Response {
        let token: FirebaseJWTPayload
        do {
            token = try await req.firebaseJwt.asyncVerify()
        } catch {
            print("Failed to verify token!")
            throw Abort(.badRequest, reason: "Unable to verify the Firebase token.")
        }
    
        if let user = try await app.repositories.users.find(firebaseId: token.userID) {
            guard let email = token.email else {
                throw Abort(.badRequest, reason: "Firebase user does not have an email.")
            }
            
            guard email == user.email else {
                throw Abort(.badRequest, reason: "Firebase user email does not match local user email.")
            }
        } else {
            guard let email = token.email else {
                throw Abort(.badRequest, reason: "Firebase user does not have an email.")
            }
            
            guard let name = token.name else {
                throw Abort(.badRequest, reason: "Firebase user does not have a name.")
            }
            
            let user = User(firebaseId: token.userID, email: email, fullName: name)
            try await app.repositories.users.create(user)
        }
        
        return Response(status: .ok)
    }
}
