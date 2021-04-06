//
//  TripViewController.swift
//  TripJournalApp
//
//  Created by user191232 on 4/4/21.
//

import UIKit
import Alamofire

class TripViewController: UIViewController {

    @IBOutlet weak var tripPhoto: UIImageView!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripLocation: UILabel!
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var tripRating: UILabel!
    @IBOutlet weak var tripDescription: UILabel!
    
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if trip == nil {
            trip = Trip(cost: 0, rating: 0)
        }
        
        self.tripName.text = "Name: \(String(describing: trip!.name!))"
        self.tripLocation.text = "Location: \(String(describing: trip!.destinationName!))"
        self.tripCost.text = "Cost: \(String(describing: trip!.cost))"
        self.tripRating.text = "Rating: \(String(describing: trip!.rating)) / 5"
        self.tripDescription.text = "Description: \(String(describing: trip!.description!))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMyTripSegue" {
            if let destinationViewController = segue.destination as? EditTripViewController {
                destinationViewController.trip = trip
            }
        }
    }
    
    @IBAction func deleteTrip(_ sender: Any) {
        // delete from db
        // TODO: what to do if the trip was favorited by others?
        
        Repository().delete(tripId: trip!.id)
        
        // delete from firebase
        let request = AF.request("\(Constants.API_URL)/trip/\(String(describing: trip!.id!))", method: .delete).validate()
        
        request.response() { response in
            guard response.error == nil else {
                print(response.error?.errorDescription?.description ?? "default value")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
