//
//  GetFirebaseToken.swift
//
//
//  Created by Alex Loren on 1/24/24.
//

import Foundation
import Vapor

struct FirebaseLoginResponse: Codable {
    let kind: String
    let localID: String
    let email: String
    let displayName: String
    let idToken: String
    let registered: Bool
    let refreshToken: String
    let expiresIn: String

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case localID = "localId"
        case email = "email"
        case displayName = "displayName"
        case idToken = "idToken"
        case registered = "registered"
        case refreshToken = "refreshToken"
        case expiresIn = "expiresIn"
    }
}

/// Logs in a dummy user to Firebase to obtain the token for testing.
/// - Returns: A newly fetched Id Token from Firebase Auth.
func getFirebaseToken() async throws -> String {
    guard let apiKey = Environment.get("FIREBASE_API_KEY"),
          let email = Environment.get("FIREBASE_USER_EMAIL"),
          let password = Environment.get("FIREBASE_USER_PASSWORD") else {
        fatalError("Unable to retrieve Firebase username or password!")
    }
    
    let jsonData = """
    {
        "email": "\(email)",
        "password": "\(password)",
        "returnSecureToken": true
    }
    """.data(using: .utf8)
    
    var request = URLRequest(url: URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(apiKey)")!)
    request.httpMethod = "POST"
    request.addValue("*/*", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONDecoder().decode(FirebaseLoginResponse.self, from: data)
    return response.idToken
}

/// Sets the given Firebase user display name to "Dummy User'.
/// - Parameters:
///   - apiKey: The Firebase API key for making requests.
///   - idToken: The token for the Firebase user to update.
func addFirebaseDisplayName(apiKey: String, idToken: String) async throws {
    let jsonData = """
    {
        "idToken": "\(idToken)",
        "displayName": "Dummy User",
        "returnSecureToken": true
    }
    """.data(using: .utf8)
    
    var request = URLRequest(url: URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:update?key=\(apiKey)")!)
    request.httpMethod = "POST"
    request.addValue("*/*", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let response = String(decoding: data, as: UTF8.self)
    print("\n\n\(response)\n\n")
}
