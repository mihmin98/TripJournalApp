//
//  EditTripViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/5/21.
//

import UIKit

class EditTripViewController: UIViewController {

    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if trip == nil {
            self.navigationItem.title = "Add Trip"
            // Create a blank trip and set the ui fields etc
        } else {
            self.navigationItem.title = "Edit Trip"
            // Set the ui fields
        }

        // Do any additional setup after loading the view.
        // if trip is null then mode is add, otherwise is edit
    }
}
