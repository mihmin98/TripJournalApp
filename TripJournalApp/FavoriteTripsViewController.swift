//
//  FavoriteTripsViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/5/21.
//

import UIKit

class FavoriteTripsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var favoriteTrips: [Trip]?
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(TripViewCell.nib(), forCellWithReuseIdentifier: TripViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let trip = Trip(id: "jeg", ownerId: "dragan", name: "cisco", photo: "", destinationName: "corea", destinationCoords: "192.168.0.3", cost: 50, rating: 2, description: "aiurea", likedBy: [])
//        repo.addTrip(trip: trip)
        Repository().addFavoriteTrip(userId: "cacat", tripId: "jeg")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get favorite trips from local db
        let repo = Repository()
        favoriteTrips = repo.readFavoriteTrips()

        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // view favorite trip segue; send trip
        if segue.identifier == "viewFavoriteTripSegue" {
            // TODO: return to this after creating the ViewOtherTrip class etc
            if let destinationViewController = segue.destination as? OtherTripViewController {
                destinationViewController.trip = selectedTrip
            }
        }
    }
}

extension FavoriteTripsViewController: UICollectionViewDelegate {
    // Called when tapping cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("pressed: \(indexPath.item)")

        selectedTrip = favoriteTrips![indexPath.item]

        // Segue to another scene
        performSegue(withIdentifier: "viewFavoriteTripSegue", sender: self)
    }
}

extension FavoriteTripsViewController: UICollectionViewDataSource {
    // Sets the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteTrips!.count
    }

    // Sets cell data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripViewCell.identifier, for: indexPath) as! TripViewCell

        cell.configure(with: favoriteTrips![indexPath.item])

        return cell
    }
}

extension FavoriteTripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width

        return CGSize(width: width * 1, height: height * 0.2)
    }
}

