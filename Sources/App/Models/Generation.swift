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
}
