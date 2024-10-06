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
    let networkMonitor = NetworkMonitor.shared
    var appCoordinator:AppCoordinator? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        showLoadingIndicator()
        setUpTabBar()
        setUpCollectionView()
        appCoordinator = AppCoordinator()
        networkMonitor.checkConnection { isConnected in
            if isConnected {
                self.networkManger = NetworkManager()
                let group = DispatchGroup()
                group.enter()
                self.setUpConnectionToApi(category: .nowPlaying, completion: { movies in
                    self.nowPlaying = movies
                    CoreDataManager.shared.saveMovies(movies: movies!)
                    group.leave()
                })
                
                group.enter()
                self.setUpConnectionToApi(category: .upcoming, completion: { movies in
                    self.upcomingMovies = movies
                    group.leave()
                })
                group.enter()
                self.setUpConnectionToApi(category: .popular, completion: { movies in
                    self.poupularMovies = movies
                    group.leave()
                })
                group.notify(queue: .main) {
                    self.hideLoadingIndicator()
                    self.view.isUserInteractionEnabled = true
                    self.handleTabSelection(index: 0)
                }
            } else {
                self.appCoordinator?.showAlert(from: self, message: .warning("there is No intere net you are in the Local Storage"))
                self.hideLoadingIndicator()
                self.view.isUserInteractionEnabled = true
                self.movies = CoreDataManager.shared.fetchFavoriteMovies()
                
                print(self.movies)
            }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else {
              return
          }
        guard let selectedImage = cell.movieImage.image else { return }
        let vc = storyboard?.instantiateViewController(withIdentifier: "showDetailSegue") as? MovieDetailsViewController
        guard let vc = vc else {return }
        vc.movieDatiles = movies?[indexPath.row]
        vc.imageView = selectedImage
        self.present(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
           let destinationVC = segue.destination as? MovieDetailsViewController,
           let indexPath = sender as? IndexPath {
            destinationVC.movieDatiles = movies?[indexPath.row]
        }
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
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator?.stopAnimating()
            self?.loadingIndicator?.removeFromSuperview()
        }
    }
}

//Mark REfressindecto
extension MoviesViewController {
   

     
     func fetchData() {
         showLoadingIndicator()
         
         // Simulating a network call
         DispatchQueue.global().async {
             // Simulate network delay
             sleep(2)
             
             // Once done, hide the loading indicator
             self.hideLoadingIndicator()
         }
     }
}
