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

    var movieDatiles:MovieDetail?
    var networkingManager : NetworkManager?
    var imageView:UIImage?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkingManager = NetworkManager()
        networkingManager?.fetchImage(with: movieDatiles!, completion:
                                        { image in
            self.movieIamge.image = image
        })
        print("MovieDetailsViewController will appear")
            setUpView()
    }

      func setUpView() {
          guard let movie = movieDatiles else {
              print("Movie is nil")
              return
          }
          movieTitle.text = movie.title
          overViewLbl.text = movie.overview
          movieRealseDate.text = movie.releaseDate
          movieIamge.image = imageView

      }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
