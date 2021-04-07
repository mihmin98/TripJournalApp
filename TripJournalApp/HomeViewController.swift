//
//  HomeViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/4/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var myTrips: [Trip]?
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(TripViewCell.nib(), forCellWithReuseIdentifier: TripViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Get the trips from local db
//        let repo = Repository()
//        myTrips = repo.readMyTrips()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get favorite trips from local db
        // TODO Fix this
        let repo = Repository()
        myTrips = repo.readMyTrips()
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewMyTripSegue" {
            if let destinationViewController = segue.destination as? TripViewController {
                destinationViewController.trip = selectedTrip
            }
        }
        
        else if segue.identifier == "addTripSegue" {
            if let destinationViewController = segue.destination as? EditTripViewController {
                destinationViewController.trip = nil
            }
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

extension HomeViewController: UICollectionViewDelegate {
    // Called when tapping cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("pressed: \(indexPath.item)")
        
        selectedTrip = myTrips![indexPath.item]
        
        // Segue to another scene
        performSegue(withIdentifier: "viewMyTripSegue", sender: self)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    // Sets the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTrips!.count
    }
    
    // Sets cell data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripViewCell.identifier, for: indexPath) as! TripViewCell
        
        cell.configure(with: myTrips![indexPath.item])
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        return CGSize(width: width * 1, height: height * 0.2)
    }
}
