//
//  StaticPagesController.swift
//
//
//  Created by Alex Loren on 12/18/23.
//

import Vapor
import Leaf
import FirebaseJWTMiddleware

struct StaticPagesController: RouteCollection {
    // MARK: - Functions.
    
    /// Groups each request into a collection.
    /// - Parameter routes: The `RoutesBuilder` object provided by the `Application`.
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: home)
        
        let protected = routes.grouped(FirebaseJWTMiddleware())
        protected.get("me", use: me)
    }
    
    /// Builds and returns the Home page.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: The view that has been built.
    func home(req: Request) async throws -> String {
        return "Home"
    }
    
    /// Builds and returns the Me page.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: The view that has been built.
    func me(req: Request) async throws -> String {
        return "Me"
    }
    
    /// Verifies the Firebase token and attempts to fetch a matching `User`.
    /// - Parameter req: The `Request` this verification is made on.
    /// - Returns: The `User` object from the database with a matching Firebase ID.
    /*
    func verifyAndGetUser(req: Request) async throws -> User {
        let token = try await req.firebaseJwt.asyncVerify()
        if let user = try await app.repositories.users.find(firebaseId: token.userID) {
            return user
        } else {
            throw Abort(.notFound, reason: "User was not found.")
        }
    }
    */
}
