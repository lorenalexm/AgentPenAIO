//
//  Application+Repositories.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor
import Fluent

extension Application {
    // MARK: - Properties
    var repositories: Repositories {
        .init(app: self)
    }
    
    struct Repositories {
        // MARK: - Properties
        let app: Application
        
        /// Verifies the `UserRepository` exists and returns it.
        var users: UserRepository {
            guard let storage = storage.makeUserRepository else {
                fatalError("UserRepository not configured, use: app.userRepository.use()")
            }
            
            return storage(app)
        }
        
        /// Returns the `Storage` object, or creates one if it doesn't exist.
        var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            
            return app.storage[Key.self]!
        }
        
        // MARK: - Functions
        func use(_ provider: Provider) {
            provider.run(app)
        }
        
        func use(_ make: @escaping (Application) -> (UserRepository)) {
            storage.makeUserRepository = make
        }
    }
}

extension Application.Repositories {
    struct Provider {
        // MARK: - Properties
        static var database: Self {
            .init {
                $0.repositories.use { UserRepository(database: $0.db) }
            }
        }
        let run: (Application) -> ()
    }
}

extension Application.Repositories {
    struct Key: StorageKey {
        typealias Value = Storage
    }
}

extension Application.Repositories {
    class Storage {
        // MARK: - Properties
        var makeUserRepository: ((Application) -> UserRepository)?
        
        // MARK: - Functions
        init() { }
    }
}
