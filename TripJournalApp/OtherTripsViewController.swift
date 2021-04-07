//
//  OtherTripsViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/5/21.
//

import UIKit
import Alamofire

class OtherTripsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var otherTrips: [Trip]?	= []
    var selectedTrip: Trip?
    
    var finishedRequest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(TripViewCell.nib(), forCellWithReuseIdentifier: TripViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if finishedRequest == false {
            getOtherTrips()
            return
        }
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutSubviews()
        
        finishedRequest = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // view favorite trip segue; send trip
        if segue.identifier == "viewOtherTripSegue" {
            if let destinationViewController = segue.destination as? OtherTripViewController {
                destinationViewController.trip = selectedTrip
            }
        }
    }
    
    private func getOtherTrips() {
        let request = AF.request("\(Constants.API_URL)/trip/others/\(CurrentUser.user.email!)", method: .get).validate()
        
        request.responseDecodable(of: [Trip].self) { response in
            guard response.error == nil else {
                print(response.error?.errorDescription?.description ?? "default value")
                return
            }
                        
            self.finishedRequest = true
            self.otherTrips = response.value
            self.viewWillAppear(false);
        }
    }
    
    
    @IBAction func signout(_ sender: Any) {
        CurrentUser.user.email = nil
        
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigationController")
        viewcontroller?.modalPresentationStyle = .fullScreen
        viewcontroller?.modalTransitionStyle = .crossDissolve
        self.present(viewcontroller!, animated: true, completion: nil)
    }
}

extension OtherTripsViewController: UICollectionViewDelegate {
    // Called when tapping cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("pressed: \(indexPath.item)")

        selectedTrip = otherTrips![indexPath.item]

        // Segue to another scene
        performSegue(withIdentifier: "viewOtherTripSegue", sender: self)
    }
}

extension OtherTripsViewController: UICollectionViewDataSource {
    // Sets the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherTrips!.count
    }

    // Sets cell data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripViewCell.identifier, for: indexPath) as! TripViewCell

        cell.configure(with: otherTrips![indexPath.item])

        return cell
    }
}

extension OtherTripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width

        return CGSize(width: width * 1, height: height * 0.2)
    }
}
