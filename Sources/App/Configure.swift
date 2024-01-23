import NIOSSL
import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    // MARK: - Database
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
    } else {
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor",
            password: Environment.get("DATABASE_PASSWORD") ?? "password",
            database: Environment.get("DATABASE_NAME") ?? "vapor",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
    }

    // MARK: - Middleware
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all, 
        allowedMethods: [.GET, .POST],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration), at: .beginning)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // MARK: - Services
    app.views.use(.leaf)
    app.repositories.use(.database)
    guard let firebaseProjectId = Environment.get("FIREBASE_PROJECT_ID") else {
        fatalError("Unable to retreive the Firebase Project Id from the environment!")
    }
    app.firebaseJwt.applicationIdentifier = firebaseProjectId
    
    // MARK: - Application Setup
    try migrations(app)
    try routes(app)
    
    if app.environment == .development {
        try await app.autoMigrate()
    }
}
