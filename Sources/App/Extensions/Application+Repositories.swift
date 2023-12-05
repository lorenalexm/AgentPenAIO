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
        
        /// Verifies the `ListingRepository` exists and returns it.
        var listings: ListingRepository {
            guard let storage = storage.makeListingRepository else {
                fatalError("ListingRepository not configured, use: app.listingRepository.use()")
            }
            
            return storage(app)
        }
        
        /// Verifies the `GenerationRepository` exists and returns it.
        var generations: GenerationRepository {
            guard let storage = storage.makeGenerationRepository else {
                fatalError("GenerationRepository not configured, use: app.generationRepository.use()")
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
        
        func use(_ make: @escaping (Application) -> (ListingRepository)) {
            storage.makeListingRepository = make
        }
        
        func use(_ make: @escaping (Application) -> (GenerationRepository)) {
            storage.makeGenerationRepository = make
        }
    }
}

extension Application.Repositories {
    struct Provider {
        // MARK: - Properties
        static var database: Self {
            .init {
                $0.repositories.use { UserRepository(database: $0.db) }
                $0.repositories.use { ListingRepository(database: $0.db) }
                $0.repositories.use { GenerationRepository(database: $0.db) }
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
        var makeListingRepository: ((Application) -> ListingRepository)?
        var makeGenerationRepository: ((Application) -> GenerationRepository)?
        
        // MARK: - Functions
        init() { }
    }
}
