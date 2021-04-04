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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(TripViewCell.nib(), forCellWithReuseIdentifier: TripViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Get the trips from local db
        let repo = Repository()
        myTrips = repo.readMyTrips()
        
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // called when tapping cell
        collectionView.deselectItem(at: indexPath, animated: true)
        print("pressed: \(indexPath.item)")
        
        // Segue to another scene
        let viewController = (self.storyboard?.instantiateViewController(identifier: "viewMyTrip"))! as TripViewController
        viewController.trip = myTrips![indexPath.item]
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
        //self.present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTrips!.count
    }
    
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
