//
//  User.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class User: Codable, Identifiable {
    
    public var email: String?
    public var password: String?
    public var username: String?
    public var favorites: [String]
    
    init(email: String? = nil, password: String? = nil, username: String? = nil, favorites: [String]) {
        self.email = email
        self.password = password
        self.username = username
        self.favorites = favorites
    }
}
