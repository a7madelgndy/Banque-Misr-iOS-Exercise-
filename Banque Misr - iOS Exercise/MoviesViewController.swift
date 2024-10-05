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
    
    var nowPlaying:[Movie]?
    var poupularMovies:[Movie]?
    var upcomingMovies:[Movie]?
    var movies :[Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    var networkManger: NetworkManager?
    var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        showLoadingIndicator()
        setUpTabBar()
        setUpCollectionView()
        networkManger = NetworkManager()
        
        let group = DispatchGroup()
        group.enter()
        setUpConnectionToApi(category: .nowPlaying, completion: { movies in
            self.nowPlaying = movies
            group.leave()
        })
        
        group.enter()
        setUpConnectionToApi(category: .upcoming, completion: { movies in
            self.upcomingMovies = movies
            group.leave()
        })
        group.enter()
        setUpConnectionToApi(category: .popular, completion: { movies in
            self.poupularMovies = movies
            group.leave()
        })
        group.notify(queue: .main) {
            self.hideLoadingIndicator()
            self.view.isUserInteractionEnabled = true
            self.handleTabSelection(index: 0)
        }
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
            movies = nowPlaying
        case 1:
            headerTitle.text = "Popular Movies"
            movies = poupularMovies
            
        case 2:
            headerTitle.text = "Upcoming Movies"
            movies = upcomingMovies
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
        return movies?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        if let movie = movies?[indexPath.row] {
            cell.setUp(with: movie)
        }
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

//MARK: netwroking
extension MoviesViewController {
    func setUpConnectionToApi(category: MovieCategory ,completion: @escaping ([Movie]?) -> Void){
        networkManger?.fetchMovies(category: category,completion: { result in
            switch result {
            case .success(let movies):
                completion(movies)
            case .failure(let error):
                completion(nil)
                print("Error fetching movies: \(error.localizedDescription)")
            }
        })
    }
}

//Mark: Indector
extension MoviesViewController {
    func showLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = self.view.center
        loadingIndicator?.startAnimating()
        self.view.addSubview(loadingIndicator!)
    }
    func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
    }
}
