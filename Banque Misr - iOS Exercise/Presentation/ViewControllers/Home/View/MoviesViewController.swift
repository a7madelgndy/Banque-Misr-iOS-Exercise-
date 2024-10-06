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
    var viewModel: MoviesViewModel!
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
        networkManager = NetworkManager()
        viewModel = MoviesViewModel(networkManager: networkManager!)
        appCoordinator = AppCoordinator()
        checkForConnection()
        setUpTabBar()
        setUpCollectionView()
        setupViewModel()
    }
    
    private func setupViewModel() {
        self.viewModel.nowPlayingDidUpdate = { [weak self] movies in
            self?.movies = movies
            
        }
        self.viewModel.popularMoviesDidUpdate = { [weak self] movies in
            self?.movies = movies
            
        }
        self.viewModel.upcomingMoviesDidUpdate = { [weak self] movies in
            self?.movies = movies
        }
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
            movies = viewModel.nowPlaying
            headerTitle.text = "Now Playing Movies"
        case 1:
            movies = viewModel.popularMovies
            headerTitle.text = "Popular Movies"
        case 2:
            movies = viewModel.upcomingMovies
            headerTitle.text = "Upcoming Movies"
        default:
            break
        }
        moviesCollectionView.reloadData()
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
        networkMonitor.checkConnection{[weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                guard let selectedMovieId = movies?[indexPath.row].id else { return }
                viewModel.networkManager?.fetchMovieDetails(for: selectedMovieId) { [weak self] result in
                    DispatchQueue.main.async {
                        self?.view.isUserInteractionEnabled = true
                        self?.hideLoadingIndicator()
                    }
                    
                    switch result {
                    case .success(let movie):
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "showDetailSegue") as! MovieDetailsViewController
                            detailVC.viewModel = MovieDetailsViewModel(networkingManager: NetworkManager())
                            detailVC.viewModel?.movieDetail = movie
                            
                            self.present(detailVC, animated: true)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            else{
                self.appCoordinator?.showAlert(from: self, message: .warning("it seems you are not connected to the internet. Please check your network settings to access the Movie Details."))
                self.view.isUserInteractionEnabled = true
                self.hideLoadingIndicator()
            }
        }
        
    }
    
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
        view.isUserInteractionEnabled = false
        showLoadingIndicator()
        networkMonitor.checkConnection { [weak self] isConnected in
            guard let self = self else { return }
            
            self.hideLoadingIndicator()
            if isConnected {
                self.viewModel.fetchMoviesData()
                self.view.isUserInteractionEnabled = true
                self.handleTabSelection(index: 0)
                
            } else {
                DispatchQueue.main.async {
                    self.appCoordinator?.showAlert(from: self, message: .warning("There is no internet! You are in Offline mode"))
                    self.viewModel.nowPlaying = CoreDataManager.shared.fetcheMovies(movieEntitie: .NowPlayingEntity)
                    self.viewModel.popularMovies = CoreDataManager.shared.fetcheMovies(movieEntitie: .PopularEntity)
                    self.viewModel.upcomingMovies = CoreDataManager.shared.fetcheMovies(movieEntitie: .UpcomingEntity)
                    self.handleTabSelection(index: 0)
                    self.view.isUserInteractionEnabled = true
                    self.hideLoadingIndicator()
                }
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
