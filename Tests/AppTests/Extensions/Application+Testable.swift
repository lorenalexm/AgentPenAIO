//
//  Application+Testable.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import XCTVapor
import App

extension Application {
    /// Creates an `Application` object with a `.testing` environment.
    /// Reverts and reruns database migrations when called.
    /// - Returns: The newly created `Application`.
    static func testable() async throws -> Application {
        let app = Application(.testing)
        
        try await configure(app)
        try await app.autoRevert()
        try await app.autoMigrate()
        
        return app
    }
}
