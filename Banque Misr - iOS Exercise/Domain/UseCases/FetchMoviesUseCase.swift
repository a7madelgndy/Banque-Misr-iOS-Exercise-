//
//  FetchMoviesUseCase.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

class FetchMoviesUseCase {
    private let movieFetcher: MovieFetchingProtocol

    init(movieFetcher: MovieFetchingProtocol) {
        self.movieFetcher = movieFetcher
    }

    func execute(category: MovieCategory, completion: @escaping ([Movie]?) -> Void) {
        movieFetcher.fetchMovies(category: category) { result in
            switch result {
            case .success(let movies):
                completion(movies)
            case .failure:
                completion(nil)
            }
        }
    }
}
