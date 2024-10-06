//
//  NetwrokManager.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 05/10/2024.
//

import Foundation
import UIKit
class NetworkManager {
    
    private let apiKey = "2c843b0224e59c561fc448832e378f65"
    
    func fetchMovies(category: MovieCategory, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(category.rawValue)") else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            // 1. Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // 2. Check for data
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            // 3. Decode data
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                completion(.success(moviesResponse.results))
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchMovieDetails(for movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // 1. Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // 2. Check for data
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            // 3. Decode data
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                completion(.success(movieDetail))
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchImage(with movie: MovieDetail, completion: @escaping (UIImage?) -> Void) {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            if let posterPath = movie.posterPath {
                let imageUrlString = baseURL + posterPath
                NetworkMonitor.shared.checkConnection { isConnected in
                    if isConnected {
                        self.loadImage(from: imageUrlString) { image in
                            completion(image)
                        }
                    } else {
                        print("No internet connection")
                        completion(nil)
                    }
                }
            } else {
                print("No poster path available")
                completion(nil)
            }
        }

        private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to load image data")
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            task.resume()
        }
}
