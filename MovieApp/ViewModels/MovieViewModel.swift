//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/11/21.
//

import UIKit

class MovieListViewModel {
    var movies = [MovieViewModel]()
    private var page = 0
    var totalPages = 0
    var totalResults = 0

    init(data: MovieData) {
        self.movies = data.results.map({MovieViewModel($0)})
        self.page = data.page
        self.totalPages = data.totalPages
        self.totalResults = data.totalResults
    }

    init(_ param: [UserMovies]) {
        self.movies = param.map({MovieViewModel($0)})
    }
}

extension MovieListViewModel {

    var nextPage: Int {
        return movies.count / 20 < totalPages ? movies.count / 20 + 1: page
    }

    var numberOfRows: Int {
        return self.movies.count
    }

    func movieAtIndex(_ index: Int) -> MovieViewModel {
        return self.movies[index]
    }

    private func containMovie(_ movie: MovieViewModel) -> Bool {
        return self.movies.contains(movie)
    }

    func checkFavourite() {

        let favourites = MovieListViewModel(Dbase.shared.getMovies())
        for (ind, item) in movies.enumerated() {
            movies[ind].isFavourite = favourites.containMovie(item) ? true : false
        }
    }

    func indexPaths(_ index: Int) -> [IndexPath] {
        return Array(index..<self.movies.count).map {IndexPath(row: $0, section: 0)}
    }

    func indexOfMovie(_ movie: MovieViewModel) -> Int? {
        return movies.firstIndex(of: movie)
    }

    func addMovies(_ movies: MovieListViewModel) {
        self.movies.append(contentsOf: movies.movies)
    }

    func removeMovie(at index: Int) {
        self.movies.remove(at: index)
    }

    func addFavourite(_ movie: MovieViewModel) {
        if let index = indexOfMovie(movie) {
            movies[index].isFavourite = true
        }
        Dbase.shared.saveMovie(movie)
    }

    func removeFavourite(_ movie: MovieViewModel) {
        if let index = MovieListViewModel(Dbase.shared.getMovies()).movies.firstIndex(of: movie) {
            Dbase.shared.removeFavourite(Dbase.shared.getMovies()[index])
            if let ind = self.movies.firstIndex(of: movie) {
                movies[ind].isFavourite = false
            }
        }
    }
}

class MovieViewModel {
    private var movie: Movie
    var isFavourite = false
    var poster: UIImage?

    init(_ movie: Movie) {
        self.movie = movie
    }

    init(_ movie: UserMovies) {
        self.movie = Movie(movie)
        self.isFavourite = true
        if let data = movie.poster {
            self.poster = UIImage(data: data)
        }
    }
}

extension MovieViewModel {

    var id: Int {
        return self.movie.id!
    }
    var title: String {
        return self.movie.title ?? ""
    }
    var originalTitle: String {
        return self.movie.originalTitle ?? ""
    }
    var overview: String {
        return self.movie.overview ?? ""
    }
    var posterPath: String {
        return self.movie.posterPath ?? ""
    }
    var releaseDate: String {
        return self.movie.releaseDate ?? ""
    }
    var voteAverage: Double {
        return self.movie.voteAverage ?? 0.0
    }
    var voteCount: Int {
        return self.movie.voteCount ?? 0
    }

}

extension MovieViewModel: Equatable {

    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.id == rhs.id
    }

}
