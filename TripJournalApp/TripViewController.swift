//
//  TripViewController.swift
//  TripJournalApp
//
//  Created by user191232 on 4/4/21.
//

import UIKit

class TripViewController: UIViewController {

    @IBOutlet weak var tripPhoto: UIImageView!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripLocation: UILabel!
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var tripRating: UILabel!
    @IBOutlet weak var tripDescription: UILabel!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var trip:Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLeftBarMenuButtonEnabled = true
                
        if trip == nil {
            trip = Trip(cost: 0, rating: 0)
        }
        
        self.tripName.text = "Name: \(String(describing: trip!.name!))"
        self.tripLocation.text = "Location: \(String(describing: trip!.destinationName!))"
        self.tripCost.text = "Cost: \(String(describing: trip!.cost))"
        self.tripRating.text = "Rating: \(String(describing: trip!.rating)) / 5"
        self.tripDescription.text = "Description: \(String(describing: trip!.description!))"
    }
    
    var addLeftBarMenuButtonEnabled: Bool? {
               didSet {
                   if addLeftBarMenuButtonEnabled! {
                       let leftBarBtn = UIButton()
                       leftBarBtn.setImage(UIImage(named: "backIcon"), for: .normal)
                       leftBarBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                       leftBarBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
                       self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
                   } else {
                       self.navigationItem.setHidesBackButton(true, animated: true)
                   }
               }
           }
           @objc func actionBackButton() {
               self.view.endEditing(true)
               self.navigationController?.popViewController(animated: true)
           }
}
