//
//  MokingMovieFetching.swift
//  Banque Misr - iOS ExerciseTests
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
@testable import Banque_Misr___iOS_Exercise
import UIKit

class MockNetworkManager: NetworkManager {
    var shouldReturnError = false
    var mockMovies: [Movie]?
    var mockMovieDetail: MovieDetail?

    override func fetchMovies(category: MovieCategory, completion: @escaping (Result<[Movie], Error>) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error fetching movies"])
            completion(.failure(error))
        } else {
            completion(.success(mockMovies ?? []))
        }
    }

    override func fetchMovieDetails(for movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error fetching movie details"])
            completion(.failure(error))
        } else {
            completion(.success(mockMovieDetail!))
        }
    }

    override func fetchImage(with movie: MovieDetail, completion: @escaping (UIImage?) -> Void) {
        let mockImage = UIImage(systemName: "photo") 
        completion(mockImage)
    }
}
