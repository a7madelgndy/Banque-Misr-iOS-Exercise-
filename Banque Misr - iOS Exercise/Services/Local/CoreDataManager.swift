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
    func saveMovies(movies: [Movie])
    func fetchFavoriteMovies() -> [Movie]
}

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton instance
    private let context: NSManagedObjectContext
    
    private init() {
           if Thread.isMainThread {
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               context = appDelegate.persistentContainer.viewContext
           } else {
               context = DispatchQueue.main.sync {
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   return appDelegate.persistentContainer.viewContext
               }
           }
       }
    
    func saveMovies(movies: [Movie]) {
        guard let entity = NSEntityDescription.entity(forEntityName: "NowPlay", in: context) else {
            print("No NowPlay entity found")
            return
        }
        
        for movie in movies {
            let nowPlayingMovie = NSManagedObject(entity: entity, insertInto: context)
            nowPlayingMovie.setValue(movie.title, forKey: "title")
            nowPlayingMovie.setValue(movie.id, forKey: "id")
            nowPlayingMovie.setValue(movie.posterPath, forKey: "poster")
        }
        
        do {
            try context.save()
            print("Movies saved successfully")
        } catch {
            print("Failed to save movies: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoriteMovies() -> [Movie] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NowPlay") 
        
        do {
            let results = try context.fetch(fetchRequest)
            // Convert to [Movie]
            return results.compactMap { result in
                if let title = result.value(forKey: "title") as? String,
                   let id = result.value(forKey: "id") as? Int,
                   let poster = result.value(forKey: "poster") as? String {
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
    
}
    /*func removeFavouriteLeague(leagueKey: Int) {
        guard let index = fetchFavouriteLeagues().firstIndex(where: { $0.leagueKey == leagueKey }) else { return }
        
        context.delete(fetchFavouriteLeagues()[index])
        
        do {
            try context.save()
        } catch {
            print("Failed to remove favorite league: \(error.localizedDescription)")
        }
    }
    
    func isFav(leagueKey: Int?) -> Bool {
        guard let leagueKey = leagueKey else { return false }
        
        return fetchFavouriteLeagues().map({ Int($0.leagueKey) }).contains(leagueKey)
    }
    
    func favToggle(league: Leagues) {
        if let leagueKey = league.leagueKey {
            isFav(leagueKey: leagueKey) ? removeFavouriteLeague(leagueKey: leagueKey) : saveFavouriteLeague(league: league)
        }
    }*/

