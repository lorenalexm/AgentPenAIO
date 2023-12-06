//
//  Generation.swift
//
//
//  Created by Alex Loren on 10/22/23.
//

import Vapor
import Fluent

final class Generation: Model {
    // MARK: - Properties
    static let schema = "generations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "listingId")
    var listing: Listing
    
    @Field(key: "type")
    var type: GenerationType
    
    @Field(key: "generated")
    var generated: String
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    // MARK: - Functions
    init() { }
    
    init(id: UUID? = nil, listing: Listing.IDValue, type: GenerationType, generated: String) {
        self.id = id
        self.$listing.id = listing
        self.type = type
        self.generated = generated
    }
}
