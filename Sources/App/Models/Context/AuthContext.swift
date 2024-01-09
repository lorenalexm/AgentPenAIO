//
//  AuthContext.swift
//
//
//  Created by Alex Loren on 1/9/24.
//

import Vapor

struct AuthContext: Encodable {
    // MARK: - Properties
    var firebaseApiKey: String
    var firebaseAuthDomain: String
    var firebaseProjectId: String
    var firebaseStorageBucket: String
    var firebaseMessageSenderId: String
    var firebaseAppId: String
}
