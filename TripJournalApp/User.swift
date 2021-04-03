//
//  User.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class User: Codable {
    
    var id: Int?
    var email: String?
    var password: String?
    var username: String?
    var favorites: [String]
    
    init(id: Int? = nil, email: String? = nil, password: String? = nil, username: String? = nil, favorites: [String]) {
        self.id = id
        self.email = email
        self.password = password
        self.username = username
        self.favorites = favorites
    }
}
