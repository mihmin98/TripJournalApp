//
//  TripViewCell.swift
//  TripJournalApp
//
//  Created by user192166 on 4/4/21.
//

import UIKit

class TripViewCell: UICollectionViewCell {

    @IBOutlet var tripPhoto: UIImageView!
    @IBOutlet var tripNameLabel: UILabel!
    @IBOutlet var tripDestinationLabel: UILabel!
    @IBOutlet var tripRatingLabel: UILabel!
    @IBOutlet var tripAuthor: UILabel!
    
    static let identifier = "TripViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with trip: Trip) {
        tripNameLabel.text = trip.name
        tripDestinationLabel.text = trip.destinationName
        tripRatingLabel.text = "\(trip.rating)/5"
        tripAuthor.text = "by \(trip.ownerId!)"
    }

    static func nib() -> UINib {
        return UINib(nibName: "TripViewCell", bundle: nil)
    }
}
