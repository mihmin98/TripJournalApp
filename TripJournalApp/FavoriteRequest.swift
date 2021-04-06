//
//  FavoriteRequest.swift
//  TripJournalApp
//
//  Created by user192166 on 4/6/21.
//

import Foundation

public class FavoriteRequest: Codable, Identifiable {
    
    var tripId: String?
    var userId: String?
    
    init(tripId: String? = nil, userId: String? = nil) {
        self.tripId = tripId
        self.userId = userId
    }
}
