//
//  FavouriteDataBase.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/20/21.
//

import Foundation
import CoreData

class Dbase{
    
    static let shared = Dbase()
    private init(){}
    
    func SaveMovie(_ movie: MovieViewModel) {
        let context = AppDelegate.coreDataContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "UserMovies", in: context)
        let movieD = UserMovies(entity: entityDescription!, insertInto: context)
        movieD.isFavourite = movie.isFavourite
        movieD.iD = Int64(movie.id)
        movieD.originalTitle = movie.originalTitle
        movieD.poster = movie.poster?.pngData()
        movieD.releaseDate = movie.releaseDate
        movieD.review = movie.overview
        movieD.title = movie.title
        movieD.voteAvarage = movie.voteAverage
        do {
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getMovies() -> [UserMovies]{
        let context = AppDelegate.coreDataContainer.viewContext
        let request: NSFetchRequest<UserMovies> = UserMovies.fetchRequest()
        var movies = [UserMovies]()
        do {
            let result = try context.fetch(request)
            
            movies = result
            
        } catch {
            print(error.localizedDescription)
        }
        return movies
    }
    
    func removeFavourite(_ movie: UserMovies){
        let context = AppDelegate.coreDataContainer.viewContext
        context.delete(movie)
        do {
            try context.save()
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
}
