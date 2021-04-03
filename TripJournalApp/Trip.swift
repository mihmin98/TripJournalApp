//
//  Trip.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class Trip: Codable, Identifiable {
    public var id: String?
    public var ownerId: String?
    public var name: String?
    public var photo: String?
    public var destinationName: String?
    public var destinationCoords: String?
    public var cost: Double
    public var rating: Int32
    public var description: String?
    public var likedBy: [String]
    
    init(id: String? = nil, ownerId: String? = nil, name: String? = nil, photo: String? = nil, destinationName: String? = nil, destinationCoords: String? = nil, cost: Double, rating: Int32, description: String? = nil, likedBy: [String]) {
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.photo = photo
        self.destinationName = destinationName
        self.destinationCoords = destinationCoords
        self.cost = cost
        self.rating = rating
        self.description = description
        self.likedBy = likedBy
    }
}
