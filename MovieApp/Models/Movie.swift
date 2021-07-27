//
//  Movie.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/11/21.
//


import UIKit

struct MovieData: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Movie {
    
    init(_ movie: UserMovies) {
        self.id = Int(movie.iD)
        self.title = movie.title
        self.originalTitle = movie.originalTitle
        self.overview = movie.review
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAvarage
        self.voteCount = Int(movie.voteCount)
        self.video = nil
        self.posterPath = nil
        self.popularity = nil
        self.originalLanguage = nil
        self.genreIDS = nil
        self.backdropPath = nil
        self.adult = nil
    }
}

