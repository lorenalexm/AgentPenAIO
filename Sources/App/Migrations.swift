//
//  Migrations.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor

/// Performs all of the database migrations for the `Application`.
/// - Parameter app: The `Application` object to run migrations on.
func migrations(_ app: Application) throws {
    app.migrations.add(CreateUser())
    app.migrations.add(CreateListing())
}
