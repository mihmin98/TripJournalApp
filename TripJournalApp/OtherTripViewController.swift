//
//  OtherTripViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/5/21.
//

import UIKit

class OtherTripViewController: UIViewController {

    @IBOutlet weak var tripPhoto: UIImageView!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripLocation: UILabel!
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var tripRating: UILabel!
    @IBOutlet weak var tripDescription: UILabel!
    
    @IBOutlet var favoriteButton: UIButton!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if trip == nil {
            trip = Trip(cost: 0, rating: 0)
        }
        
        // check if current trip is in favorites
        favoriteButton.setTitle("Favorite", for: .normal)
        
        let favoriteTrips = Repository().readFavoriteTrips()
        for t in favoriteTrips {
            if trip?.id == t.id {
                favoriteButton.setTitle("Unfavorite", for: .normal)
                break
            }
        }
        
        self.tripName.text = "Name: \(String(describing: trip!.name!))"
        self.tripLocation.text = "Location: \(String(describing: trip!.destinationName!))"
        self.tripCost.text = "Cost: \(String(describing: trip!.cost))"
        self.tripRating.text = "Rating: \(String(describing: trip!.rating)) / 5"
        self.tripDescription.text = "Description: \(String(describing: trip!.description!))"
    }
    
    @IBAction func pressedFavoriteButton(_ sender: Any) {
        let repo = Repository()
        if favoriteButton.currentTitle == "Favorite" {
            // Add to favorites
            repo.addTrip(trip: trip!)
            repo.addFavoriteTrip(userId: CurrentUser.user.email!, tripId: trip!.id!)
            // TODO: send to api that favorites have been updated
            
            favoriteButton.setTitle("Unfavorite", for: .normal)
        } else {
            // Remove from favorites
            repo.deleteFavoriteTrip(userId: CurrentUser.user.email!, tripId: trip!.id!)
            repo.delete(tripId: trip!.id)
            // TODO: Send to api that favorites have been updated
            
            favoriteButton.setTitle("Favorite", for: .normal)
        }
    }
}
