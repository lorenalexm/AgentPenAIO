//
//  Routes.swift
//  
//
//  Created by Alex Loren on 12/18/23.
//

import Vapor

/// Registers all of the `Route` and `RouteCollection` objects.
/// - Parameter app: The `Application` object to run migrations on.
func routes(_ app: Application) throws {
    try app.register(collection: StaticPagesController())
    try app.register(collection: AuthController(app: app))
}
