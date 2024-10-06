//
//  Movie.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 05/10/2024.
//

import Foundation


    //قoot
struct MoviesResponse: Decodable {
    let results: [Movie]
    let page: Int
    let totalResults: Int
    let totalPages: Int

    
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?

}
