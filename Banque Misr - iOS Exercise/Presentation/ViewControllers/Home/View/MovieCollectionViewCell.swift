//
//  MovieCollectionViewCell.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 05/10/2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var movieImage: UIImageView!
    
    func setUp(with movie: Movie){
        titleLbl.text = movie.title
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie.posterPath {
            let imageUrlString = baseURL + posterPath
            NetworkMonitor.shared.checkConnection { isconnected in
                if isconnected {
                    self.loadImage(from: imageUrlString)
                }
                else {
                    self.movieImage.image = UIImage(named: "1")
                }
            }
           
        } else {
            movieImage.image = UIImage(named: "1")
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        movieImage.image = nil
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image data")
                return
            }
            
            DispatchQueue.main.async {
                self.movieImage.image = image
            }
        }
        
        task.resume()
    }
}

