//
//  MoviesViewModel.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation

class MoviesViewModel {
    var nowPlaying: [Movie]? {
        didSet {
            nowPlayingDidUpdate?(nowPlaying)
        }
    }
    var popularMovies: [Movie]? {
        didSet {
            popularMoviesDidUpdate?(popularMovies)
        }
    }
    var upcomingMovies: [Movie]? {
        didSet {
            upcomingMoviesDidUpdate?(upcomingMovies)
        }
    }
    var nowPlayingDidUpdate: (([Movie]?) -> Void)?
    var popularMoviesDidUpdate: (([Movie]?) -> Void)?
    var upcomingMoviesDidUpdate: (([Movie]?) -> Void)?
    
    var networkManager: NetworkManager?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchMoviesData() {
        let group = DispatchGroup()
        
        group.enter()
        setUpConnectionToApi(category: .nowPlaying) { movies in
            self.nowPlaying = movies
            DispatchQueue.main.async {
                CoreDataManager.shared.saveMovies(movies: movies ?? [], movieEntitie: .NowPlayingEntity)
            }
            group.leave()
        }
        
        group.enter()
        setUpConnectionToApi(category: .upcoming) { movies in
            self.upcomingMovies = movies
            DispatchQueue.main.async {
                CoreDataManager.shared.saveMovies(movies: movies ?? [], movieEntitie: .UpcomingEntity)
            }
            group.leave()
        }
        
        group.enter()
        setUpConnectionToApi(category: .popular) { movies in
            self.popularMovies = movies
            DispatchQueue.main.async {
                CoreDataManager.shared.saveMovies(movies: movies ?? [], movieEntitie: .PopularEntity)
            }
            group.leave()
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
