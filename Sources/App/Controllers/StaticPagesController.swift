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
        routes.get("authentication", use: authentication)
        routes.get("me", use: me)
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
    
    /// Builds and returns the Authentication page.
    /// - Parameter req: Information about the request that was received.
    /// - Returns: The view that has been built.
    func authentication(req: Request) async throws -> View {
        guard let firebaseApiKey = Environment.get("FIREBASE_API_KEY"),
              let firebaseAuthDomain = Environment.get("FIREBASE_AUTH_DOMAIN"),
              let firebaseProjectId = Environment.get("FIREBASE_PROJECT_ID"),
              let firebaseStorageBucket = Environment.get("FIREBASE_STORAGE_BUCKET"),
              let firebaseMessageSenderId = Environment.get("FIREBASE_MESSAGE_SENDER_ID"),
              let firebaseAppId = Environment.get("FIREBASE_APP_ID") else {
            fatalError("Unable to retrieve Firebase environment values!")
        }
        
        let context = FirebaseContext(apiKey: firebaseApiKey,
                                  authDomain: firebaseAuthDomain,
                                  projectId: firebaseProjectId,
                                  storageBucket: firebaseStorageBucket,
                                  messageSenderId: firebaseMessageSenderId,
                                  appId: firebaseAppId)
        return try await req.view.render("Authentication", context)
    }
}
