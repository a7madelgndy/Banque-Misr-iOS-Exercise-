//
//  MovieDetailsViewModel.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
import UIKit


class MovieDetailsViewModel {
    private var networkingManager: ImageLoadingProtocol
    var movieDetail: MovieDetail?

    init(networkingManager: ImageLoadingProtocol) {
        self.networkingManager = networkingManager
    }

    func fetchMovieImage(completion: @escaping (UIImage?) -> Void) {
        guard let movieDetail = movieDetail else {
            completion(nil)
            return
        }

        networkingManager.fetchImage(with: movieDetail) { image in
            completion(image)
        }
    }
}
