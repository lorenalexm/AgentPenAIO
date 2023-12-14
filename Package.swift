// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AgentPenAIO",
    platforms: [
       .macOS(.v13),
       .iOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.83.1"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.5.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
        .package(url: "https://github.com/vapor/queues.git", from: "1.13.0"),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.1.1"),
        .package(url: "https://github.com/emvakar/vapor-firebase-jwt-middleware.git", branch: "master"),
        .package(url: "https://github.com/vapor-community/stripe-kit.git", from: "22.0.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "QueuesRedisDriver", package: "queues-redis-driver"),
                .product(name: "FirebaseJWTMiddleware", package: "vapor-firebase-jwt-middleware"),
                .product(name: "StripeKit", package: "stripe-kit")
            ]
        ),
        .executableTarget(name: "Run",
                          dependencies: [
                            .target(name: "App")
                          ]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "XCTQueues", package: "queues"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Fakery", package: "fakery")
        ])
    ]
)
