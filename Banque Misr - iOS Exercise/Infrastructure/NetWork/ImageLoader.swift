//
//  ImageLoader.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
import UIKit
class ImageLoader {
    private let baseURL = "https://image.tmdb.org/t/p/w500"

    func fetchImage(with posterPath: String?, completion: @escaping (UIImage?) -> Void) {
        guard let posterPath = posterPath, let url = URL(string: baseURL + posterPath) else {
            print("Invalid poster path")
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
