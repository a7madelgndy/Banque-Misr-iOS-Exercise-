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
    
    var nowPlaying: [Movie]?
    var popularMovies: [Movie]?
    var upcomingMovies: [Movie]?
    var isThereInternetConnection : Bool?
    
    var movies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    var networkManager: NetworkManager?
    var loadingIndicator: UIActivityIndicatorView?
    let networkMonitor = NetworkMonitor.shared
    var appCoordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        showLoadingIndicator()
        setUpTabBar()
        setUpCollectionView()
        appCoordinator = AppCoordinator()
        checkForConnection()
    }
 
}

extension MoviesViewController: UITabBarDelegate {
    func setUpTabBar() {
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        handleTabSelection(index: 0)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            handleTabSelection(index: index)
        }
    }
    
    func handleTabSelection(index: Int) {
        switch index {
        case 0:
            headerTitle.text = "Now Playing Movies"
            movies = nowPlaying
        
        case 1:
            headerTitle.text = "Popular Movies"
            movies = popularMovies
        case 2:
            headerTitle.text = "Upcoming Movies"
            movies = upcomingMovies
        default:
            break
        }
    }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.isUserInteractionEnabled = false
        showLoadingIndicator()
        guard let selectedMovie = movies?[indexPath.row].id else { return }
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "showDetailSegue") as! MovieDetailsViewController
        
        networkManager?.fetchMovieDetails(for: selectedMovie
                                          , completion: { result in
            switch result {
                
            case .success(let movie ):
                print("joi")
                print(type(of: movie))
                print("ddf")
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.hideLoadingIndicator()
                    detailVC.movieDatiles = movie
                    self.present(detailVC, animated: true)
                }
               
            case .failure(let eror):
                print(eror)
            }
            
        })
        
    }
    
   /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
           let destinationVC = segue.destination as? MovieDetailsViewController,
           let indexPath = sender as? IndexPath {
            destinationVC.movieDatiles = movies?[indexPath.row]
        }
    */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let itemsPerRow: CGFloat = 3
        let totalPadding = padding * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - totalPadding
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: 200)
    }
}

extension MoviesViewController {
    func checkForConnection() {
        networkMonitor.checkConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                isThereInternetConnection = true
                self.networkManager = NetworkManager()
                self.fetchMoviesData()
            } else {
                isThereInternetConnection = false
                self.appCoordinator?.showAlert(from: self, message: .warning("There is no internet; you are using local storage."))
                self.hideLoadingIndicator()
                self.view.isUserInteractionEnabled = true
                //self.nowPlaying = CoreDataManager.shared.fetcheMovies(entit: "NowPlaying")
              //  self.upcomingMovies = CoreDataManager.shared.fetcheMovies(entit: "Upcoming")
               // self.popularMovies =  CoreDataManager.shared.fetcheMovies(entit: "Popular")
                
            }
        }
    }
    
    func fetchMoviesData() {
        let group = DispatchGroup()
        group.enter()
        self.setUpConnectionToApi(category: .nowPlaying) { movies in
            self.nowPlaying = movies
          DispatchQueue.main.async {
                CoreDataManager.shared.saveMovies(movies: movies ?? [] )
          }
            group.leave()
        }
        
        group.enter()
        self.setUpConnectionToApi(category: .upcoming) { movies in
            self.upcomingMovies = movies
           //CoreDataManager.shared.saveMovies(movies: movies ?? [], movieEntity: "Upcoming")
            group.leave()
        }
        
        group.enter()
        self.setUpConnectionToApi(category: .popular) { movies in
            self.popularMovies = movies
           // CoreDataManager.shared.saveMovies(movies: movies ?? [], movieEntity: "Popular")
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.hideLoadingIndicator()
            self.view.isUserInteractionEnabled = true
            self.handleTabSelection(index: 0)
        }
    }
    
    func setUpConnectionToApi(category: MovieCategory, completion: @escaping ([Movie]?) -> Void) {
        networkManager?.fetchMovies(category: category) { result in
            switch result {
            case .success(let movies):
                completion(movies)
            case .failure(let error):
                completion(nil)
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
}

extension MoviesViewController {
    func showLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = self.view.center
        loadingIndicator?.startAnimating()
        self.view.addSubview(loadingIndicator!)
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator?.stopAnimating()
            self?.loadingIndicator?.removeFromSuperview()
        }
    }
}

