//
//  OtherTripViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/5/21.
//

import UIKit
import Alamofire

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
        
        if trip?.photo != nil && trip?.photo != "" {
            // Get photo
            let request = AF.request("\(Constants.API_URL)/trip/photo/\(trip!.photo!)", method: .get).validate()
            
            request.response { response in
                guard response.error == nil else {
                    print(response.error?.errorDescription?.description ?? "default value")
                    return
                }
                
                let base64Photo = response.value!
                let imageData  = Data.init(base64Encoded: base64Photo!, options: .init(rawValue: 0))
                self.tripPhoto.image = UIImage(data: imageData!)
            }
        }
    }

    
    @IBAction func pressedFavoriteButton(_ sender: Any) {
        let repo = Repository()
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        self.view.layer.add(animation, forKey: "shake")
        if favoriteButton.currentTitle == "Favorite" {
            // Add to favorites
            repo.addTrip(trip: trip!)
            repo.addFavoriteTrip(userId: CurrentUser.user.email!, tripId: trip!.id!)
            
            let requestBody = FavoriteRequest(tripId: trip!.id!, userId: CurrentUser.user.email!)
            let request = AF.request("\(Constants.API_URL)/trip/like", method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default).validate()
            
            request.response() { response in
                guard response.error == nil else {
                    print(response.error?.errorDescription?.description ?? "default value")
                    return
                }
            }
            
            favoriteButton.setTitle("Unfavorite", for: .normal)
        } else {
            // Remove from favorites
            repo.deleteFavoriteTrip(userId: CurrentUser.user.email!, tripId: trip!.id!)
            repo.delete(tripId: trip!.id)
            
            let requestBody = FavoriteRequest(tripId: trip!.id!, userId: CurrentUser.user.email!)
            let request = AF.request("\(Constants.API_URL)/trip/unlike", method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default).validate()
            
            request.response() { response in
                guard response.error == nil else {
                    print(response.error?.errorDescription?.description ?? "default value")
                    return
                }
            }
            
            favoriteButton.setTitle("Favorite", for: .normal)
        }
    }
}
