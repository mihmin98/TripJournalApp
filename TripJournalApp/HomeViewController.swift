//
//  HomeViewController.swift
//  TripJournalApp
//
//  Created by user192166 on 4/4/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(TripViewCell.nib(), forCellWithReuseIdentifier: TripViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // called when tapping cell
        collectionView.deselectItem(at: indexPath, animated: true)
        print("pressed: \(indexPath)")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripViewCell.identifier, for: indexPath) as! TripViewCell
        
        cell.configure(with: "Test String")
        
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
