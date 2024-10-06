//
//  MovieDetailsViewController.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet var movieIamge: UIImageView!
    @IBOutlet var movieRealseDate: UILabel!

    @IBOutlet var overViewLbl: UILabel!
    @IBOutlet var movieTitle: UILabel!

    var viewModel: MovieDetailsViewModel?

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setUpView()
            fetchMovieImage()
        }
        
        func setUpView() {
            guard let movie = viewModel?.movieDetail else {
                print("Movie is nil")
                return
            }
            movieTitle.text = movie.title
            overViewLbl.text = movie.overview
            movieRealseDate.text = "Release Date: " + movie.releaseDate
        }

        private func fetchMovieImage() {
            viewModel?.fetchMovieImage { [weak self] image in
                DispatchQueue.main.async {
                    self?.movieIamge.image = image ?? UIImage(named: "1")
                }
            }
        }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
