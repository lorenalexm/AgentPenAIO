//
//  File.swift
//  
//
//  Created by Alex Loren on 1/24/24.
//

import Vapor
import FirebaseJWTMiddleware

extension Request {
    // MARK: - Functions.
    
    /// Verifies the Firebase token from the Bearer header.
    /// - Returns: The decoded `FirebaseJWTPayload` from the token.
    func verifyToken() async throws-> FirebaseJWTPayload {
        let payload: FirebaseJWTPayload
        do {
            payload = try await firebaseJwt.asyncVerify()
        } catch {
            throw Abort(.badRequest, reason: "Unable to verify the Firebase token.")
        }
        return payload
    }
}
