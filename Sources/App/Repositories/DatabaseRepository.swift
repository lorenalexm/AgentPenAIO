//
//  DatabaseRepository.swift
//
//
//  Created by Alex Loren on 9/28/23.
//

import Vapor
import Fluent

protocol DatabaseRepository: Repository {
    // MARK: - Properties
    var database: Database { get }
    
    // MARK: - Functions
    init(database: Database)
}

extension DatabaseRepository {
    // MARK: - Functions
    func `for`(_ req: Request) -> Self {
        return Self.init(database: req.db)
    }
}
