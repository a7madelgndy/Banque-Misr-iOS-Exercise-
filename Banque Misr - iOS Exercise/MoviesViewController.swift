//
//  ViewController.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 05/10/2024.
//

import UIKit

class MoviesViewController: UIViewController,UITabBarControllerDelegate {
    
    @IBOutlet var headerTitle: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var moviesCollectionView: UICollectionView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        setUpCollectionView()
        
    }
    
}
//MARK: TabBar
extension MoviesViewController:UITabBarDelegate {
    func setUpTabBar() {
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        handleTabSelection(index: 0)
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            print("Selected tab index: \(index)")
            handleTabSelection(index: index)
        }
    }
    
    func handleTabSelection(index: Int) {
        switch index {
        case 0:
            headerTitle.text = "Now playing Movies"
        case 1:
            headerTitle.text = "Popular Movies"
            
        case 2:
            headerTitle.text = "Upcoming Movies"
        default:
            break
        }
    }
}

//MARK: Movies collection View
extension MoviesViewController:UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func setUpCollectionView() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
    }
    //number of  items in the row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 //padding
        let itemsPerRow: CGFloat = 3// number of items
        let totalPadding = padding * (itemsPerRow + 1) // padding between items and edges
        let availableWidth = collectionView.frame.width - totalPadding
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
}



