//
//  Trip.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class Trip: Codable {
    var id: String?
    var ownerId: String?
    var name: String?
    var photo: String?
    var destinationName: String?
    var destinationCoords: String?
    var cost: Double
    var rating: Int
    var description: String?
    var likedBy: [String]
    
    init(id: String? = nil, ownerId: String? = nil, name: String? = nil, photo: String? = nil, destinationName: String? = nil, destinationCoords: String? = nil, cost: Double, rating: Int, description: String? = nil, likedBy: [String]) {
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
