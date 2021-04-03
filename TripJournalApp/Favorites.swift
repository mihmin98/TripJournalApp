//
//  Favorites.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class Favorites: Codable, Identifiable {
    
   public var id: Int32?
   public var userId: String?
   public var tripId: String?
    
    init(id: Int32? = nil, userId: String? = nil, tripId: String? = nil) {
        self.id = id
        self.userId = userId
        self.tripId = tripId
    }
}
