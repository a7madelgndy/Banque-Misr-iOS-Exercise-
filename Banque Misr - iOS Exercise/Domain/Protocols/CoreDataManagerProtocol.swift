//
//  CoreDataManagerProtocol.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation

protocol CoreDataManagerProtocol {
    func saveMovies(movies: [Movie], movieEntitie: MovieEntityType)
    func fetcheMovies(movieEntitie: MovieEntityType) -> [Movie]
}
