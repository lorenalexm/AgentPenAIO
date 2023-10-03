//
//  Listing.swift
//
//
//  Created by Alex Loren on 10/3/23.
//

import Vapor
import Fluent

final class Listing: Model {
    // MARK: - Properties
    static let schema = "listings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userId")
    var user: User
    
    @Field(key: "streetAddress")
    var streetAddress: String
    
    @Field(key: "city")
    var city: String
    
    @Field(key: "state")
    var state: String
    
    @Field(key: "structureType")
    var structureType: String
    
    @Field(key: "architectureType")
    var architectureType: String
    
    @Field(key: "bedrooms")
    var bedrooms: Int
    
    @Field(key: "bathrooms")
    var bathrooms: Float
    
    @Field(key: "squareFeet")
    var squareFeet: Int
    
    @Field(key: "acerage")
    var acerage: Float
    
    @Field(key: "propertyFeatures")
    var propertyFeatures: String
    
    @Field(key: "communityAmenities")
    var communityAmenities: String
    
    @Field(key: "writingStyle")
    var writingStyle: String
    
    @Field(key: "characterLimit")
    var characterLimit: Int
    
    @Field(key: "socialHashtags")
    var socialHashtags: Bool
    
    @Field(key: "socialEmoji")
    var socialEmoji: Bool
    
    @Field(key: "revisions")
    var revisions: Int
    
    // MARK: - Functions
    init() { }
    
    /// Creates a `Listing` object.
    /// - Parameters:
    ///   - id: A unique identifier for this `Listing`.
    ///   - userId: A unique identifier for the `User` parent.
    init(id: UUID? = nil,
         userId: User.IDValue,
         streetAddress: String,
         city: String,
         state: String,
         structureType: String,
         architectureType: String,
         bedrooms: Int,
         bathrooms: Float,
         squareFeet: Int,
         acerage: Float,
         propertyFeatures: String,
         communityAmenities: String,
         writingStyle: String,
         characterLimit: Int,
         socialHashtags: Bool,
         socialEmoji: Bool,
         revisions: Int) {
        self.id = id
        self.$user.id = userId
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.structureType = structureType
        self.architectureType = architectureType
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.squareFeet = squareFeet
        self.acerage = acerage
        self.propertyFeatures = propertyFeatures
        self.communityAmenities = communityAmenities
        self.writingStyle = writingStyle
        self.characterLimit = characterLimit
        self.socialHashtags = socialHashtags
        self.socialEmoji = socialEmoji
        self.revisions = revisions
    }
}
