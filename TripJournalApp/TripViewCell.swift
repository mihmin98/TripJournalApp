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
    
    static let identifier = "TripViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with text: String) {
        tripNameLabel.text = text
        tripDestinationLabel.text = "trip destination"
        tripRatingLabel.text = "5/5"
    }

    static func nib() -> UINib {
        return UINib(nibName: "TripViewCell", bundle: nil)
    }
}
