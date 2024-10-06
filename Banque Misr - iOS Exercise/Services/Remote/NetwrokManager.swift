//
//  NetwrokManager.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 05/10/2024.
//

import Foundation
class NetworkManager {
    func fetchMovies(category: MovieCategory ,completion: @escaping (Result<[Movie], Error>) -> Void)  {
        let apiKey = "2c843b0224e59c561fc448832e378f65"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(category.rawValue)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        
        let sesstion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesstion.dataTask(with: request){ data,response, error in
            
            // 1.check for error =
             if let error = error {
                  print("Error: \(error.localizedDescription)")
                  completion(.failure(error))
                    return
                    }
            // 2.check for data existing
              guard let data = data else  {
                  let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                      completion(.failure(noDataError))
                      return
                  }
        
            //3.Decoding
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                completion(.success(moviesResponse.results))
                
            }
            catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
}
