//
//  CoreDataManager.swift
//  Banque Misr - iOS Exercise
//
//  Created by Ahmed El Gndy on 06/10/2024.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func saveMovies(movies: [Movie], movieEntity: String)
    func fetchFavoriteMovies() -> [Movie]
}

class CoreDataManager {
    static let shared = CoreDataManager() // singleton
    private var context: NSManagedObjectContext
    
    private init() {
    
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
            
        }
        
        
        
        func saveMovies(movies: [Movie],movieEntitie : MovieEntityType) {
            guard let entity = NSEntityDescription.entity(forEntityName: movieEntitie.rawValue , in: context) else {return}
            
            
            let existingMovieIDs = Set(fetchMovieIDs(for: movieEntitie.rawValue))
            
            for movie in movies {
                if !existingMovieIDs.contains(movie.id) {
                    let movieObject = NSManagedObject(entity: entity, insertInto: context)
                    movieObject.setValue(movie.title, forKey: "title")
                    movieObject.setValue(movie.id, forKey: "id")
                    movieObject.setValue(movie.posterPath, forKey: "posterPath")
                }
            }
            saveContext()
        }
        func fetcheMovies(movieEntitie : MovieEntityType) -> [Movie] {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: movieEntitie.rawValue)
            
            do {
                let results = try context.fetch(fetchRequest)
                return results.compactMap { result in
                    if let title = result.value(forKey: "title") as? String,
                       let id = result.value(forKey: "id") as? Int,
                       let poster = result.value(forKey: "posterPath") as? String {
                        return Movie(id: id, title: title, posterPath: poster)
                    } else {
                        return nil
                    }
                }
            } catch {
                print("Failed to fetch favorite movies: \(error.localizedDescription)")
                return []
            }
        }
        
         func fetchMovieIDs(for entity: String) -> [Int] {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity )
            do {
                let results = try context.fetch(fetchRequest)
                return results.compactMap { $0.value(forKey: "id") as? Int }
            } catch {
                print("Failed to fetch movie IDs: \(error.localizedDescription)")
                return []
            }
        }
        
         func saveContext() {
            if context.hasChanges {
                do {
                    try context.save()
                    print("Movies saved successfully")
                } catch {
                    print("Failed to save movies: \(error.localizedDescription)")
                }
            }
        }
    }
    

enum MovieEntityType: String {
    case PopularEntity = "PopularEntity"
    case UpcomingEntity = "UpcomingEntity"
    case NowPlayingEntity = "NowPlayingEntity"

}
