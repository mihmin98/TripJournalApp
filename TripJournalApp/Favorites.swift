//
//  Favorites.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class Favorites: Codable {
    
    var id: Int?
    var userId: Int?
    var tripId: Int?
    
    init(id: Int? = nil, userId: Int? = nil, tripId: Int? = nil) {
        self.id = id
        self.userId = userId
        self.tripId = tripId
    }
}
