//
//  MovieFetchProtocol.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation

protocol MovieFetchingProtocol {
    func fetchMovies(category: MovieCategory, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovieDetails(for movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void)
}
