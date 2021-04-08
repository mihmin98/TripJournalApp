//
//  PhotoUploadRequest.swift
//  TripJournalApp
//
//  Created by user192166 on 4/8/21.
//

import Foundation

public class PhotoUploadRequest: Codable, Identifiable {
    
    var tripId: String?
    var photoBase64Encoded: String?
    
    init(tripId: String? = nil, photoBase64Encoded: String? = nil) {
        self.tripId = tripId
        self.photoBase64Encoded = photoBase64Encoded
    }
    
}
