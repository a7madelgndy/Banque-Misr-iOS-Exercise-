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
    @IBOutlet var movieOverViewTextView: UITextView!
    @IBOutlet var movieTitle: UILabel!
    var Mtitle:String?
    var movieDatiles:Movie?
    var imageView:UIImage?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MovieDetailsViewController will appear")
            setUpView()
    }

      func setUpView() {
          guard let movie = movieDatiles else {
              print("Movie is nil")
              return
          }
          movieTitle.text = movie.title
          movieIamge.image = imageView

      }
  }
