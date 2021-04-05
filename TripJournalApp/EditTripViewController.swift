//
//  EditTripViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/5/21.
//

import UIKit
import Alamofire

class EditTripViewController: UIViewController, UITextFieldDelegate {

    var trip: Trip?

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripLocation: UITextField!
    @IBOutlet weak var tripDestination: UITextField!
    @IBOutlet weak var tripCost: UITextField!
    @IBOutlet weak var tripRating: UITextField!
    @IBOutlet weak var tripDescription: UITextField!

    let emptyName = UIAlertController(title: "Trip name is empty!",
                          message: "Please fill trip name", preferredStyle: .alert)
    let emptyLocation = UIAlertController(title: "Trip location is empty!",
                          message: "Please fill trip location", preferredStyle: .alert)
    let emptyDestination = UIAlertController(title: "Trip destination is empty!",
                          message: "Please fill trip destination", preferredStyle: .alert)
    let emptyCost = UIAlertController(title: "Trip cost is empty!",
                          message: "Please fill trip cost", preferredStyle: .alert)

    let emptyRating = UIAlertController(title: "Trip rating is empty!",
                          message: "Please fill trip rating", preferredStyle: .alert)

    let emptyDescription = UIAlertController(title: "Trip description is empty!",
                          message: "Please fill trip description", preferredStyle: .alert)
    let createdTripAlert = UIAlertController(title: "Created Trip", message: "Successfully created trip", preferredStyle: .alert)
    
    override func viewDidLoad() {
    super.viewDidLoad()

    tripName.delegate = self
    tripLocation.delegate = self
    tripDestination.delegate = self
    tripCost.delegate = self
    tripRating.delegate = self
    tripDescription.delegate = self

    emptyName.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
    emptyLocation.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
    emptyDestination.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
    emptyCost.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
    emptyRating.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
    emptyDescription.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in }))
    createdTripAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//        let homeViewController = self.storyboard?.instantiateViewController(identifier: "myTrips")
//        homeViewController?.modalPresentationStyle = .fullScreen
//        homeViewController?.modalTransitionStyle = .crossDissolve
//        self.present(homeViewController!, animated: true, completion: nil)
    }))


    if trip == nil {
        self.navigationItem.title = "Add Trip"
        // Create a blank trip and set the ui fields etc
    } else {
        self.navigationItem.title = "Edit Trip"
        // Set the ui fields
        tripName.text = trip?.name
        tripLocation.text = trip?.destinationCoords
        tripDestination.text = trip?.destinationName
        tripCost.text = String(trip!.cost)
        tripRating.text = String(trip!.rating)
        tripDescription.text = trip?.description
    }

    // Do any additional setup after loading the view.
    // if trip is null then mode is add, otherwise is edit
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard
    textField.resignFirstResponder()
    return true
    }

    @IBAction func saveTrip(_ sender: Any) {
    if trip == nil {
        //add
        addNewTrip()
        return
    }
        //edit
        editTrip(trip: self.trip!)
    }

    func addNewTrip() {
        let newTrip = Trip(ownerId: CurrentUser.user.email!, name: tripName.text!, photo: "", destinationName: tripDestination.text!, destinationCoords: tripLocation.text!, cost: Double(tripCost.text!)!, rating: Int32(tripRating.text!)!, description: tripDescription.text!, likedBy: [CurrentUser.user.email!])
    

    let request = AF.request("\(Constants.API_URL)/trip",
                             method: .post, parameters: newTrip, encoder: JSONParameterEncoder.default).validate()

    request.responseDecodable(of: Trip.self) { response in
        guard response.error == nil else {
            print(response.error?.errorDescription?.description ?? "default value")
            self.present(self.createdTripAlert, animated: true, completion: nil)
            return
        }
        
        let createdTrip = response.value!
        self.present(self.createdTripAlert, animated: true, completion: nil)
        
        let repository = Repository()

        repository.addTrip(trip: createdTrip)
       }
    }
    
    func editTrip(trip: Trip) {
        
        print(trip)
        let request = AF.request("\(Constants.API_URL)/trip",
                                 method: .put, parameters: trip, encoder: JSONParameterEncoder.default).validate()

        request.responseDecodable(of: Trip.self) { response in
            guard response.error == nil else {
                print(response.error?.errorDescription?.description ?? "default value")
                self.present(self.createdTripAlert, animated: true, completion: nil)
                return
            }
            
            self.present(self.createdTripAlert, animated: true, completion: nil)
            let repository = Repository()
            
            repository.update(trip: trip)
        }
    }
}
