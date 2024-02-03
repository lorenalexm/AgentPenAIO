//
//  ListingController.swift
//
//
//  Created by Alex Loren on 2/2/24.
//

import Vapor
import FirebaseJWTMiddleware

struct ListingController: RouteCollection {
    // MARK: - Properties.
    let app: Application
    
    // MARK: - Functions.
    
    /// Groups each request into a collection.
    /// - Parameter routes: The `RoutesBuilder` object provided by the `Application`.
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        let grouped = api.grouped("listing")
        grouped.get(":id", use: get)
        grouped.get(use: all)
    }
    
    /// Returns all `Listing` objects based on the `User` Firebase Id.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: An array of `Listing` objects.
    func all(req: Request) async throws -> [Listing] {
        let token = try await req.verifyToken()
        guard let listings = try await app.repositories.listings.all(ownedBy: token.userID) else {
            throw Abort(.noContent, reason: "Unable to find any Listings.")
        }
        
        return listings
    }
    
    /// Returns a `Listing` based on the `User` Firebase Id.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: A matching `Listing` object.
    func get(req: Request) async throws -> Listing {
        let token = try await req.verifyToken()
        guard let param = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Missing Id parameter for Listing.")
        }
        
        guard let listingId = UUID(uuidString: param) else {
            throw Abort(.badRequest, reason: "Unable to create unique Id from parameter.")
        }
        
        guard let listing = try await app.repositories.listings.find(id: listingId, ownedBy: token.userID) else {
            throw Abort(.notFound, reason: "Unable to find a Listing with that Id.")
        }
        
        return listing
    }
}
