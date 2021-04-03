//
//  LoginRequest.swift
//  TripJournalApp
//
//  Created by user191232 on 4/3/21.
//

import Foundation

public class LoginRequest: Codable, Identifiable {
    
    var email: String?
    var password: String?
    
    init(email: String? = nil, password: String? = nil) {
        self.email = email
        self.password = password
    }
    
}
