//
//  FavoriteTripViewController.swift
//  TripJournalApp
//
//  Created by user191232 on 4/4/21.
//

import UIKit

class FavoriteTripViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var rating: UILabel!

    @IBOutlet weak var tripDescription: UILabel!
    
    
    var trip:Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = "Name: \(String(describing: trip?.name))"
        self.location.text = "Location: \(String(describing: trip?.destinationName))"
        self.cost.text = "Cost: \(String(describing: trip?.cost))"
        self.rating.text = "Rating: \(String(describing: trip?.rating)) / 5"
        self.tripDescription.text = "Description: \(String(describing: trip?.description))"
    }
    


}
