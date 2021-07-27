//
//  ApiDataToViewModel.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/26/21.
//

import Foundation

enum Type: String, CaseIterable {
    case topRated = "top_rated?"
    case popular = "popular?"
    case upcoming = "upcoming?"
    case favourites = "Favourites"
    case search
    case similar = "/similar?"
    case video = "/videos?"

    var stringValue: String {
        switch self {
        case .topRated:
            return "Top Rated"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .favourites:
            return "Favourites"
        case .search:
            return "Search"
        case .similar:
            return "Similar"
        case .video:
            return "Video"
        }
    }
}

class ApiCall {

    static let shared = ApiCall()
    private var movieID = ""
    private var movieType: Type = Type.topRated {
        didSet {
            if movieType == .search {
                url = "\(Constants.search)&query=\(searchMoive)&api_key=\(ApiKeys.apiKey)&page=1"
            } else if movieType == .similar {
                url = "\(Constants.url)\(movieID)\(movieType.rawValue)&api_key=\(ApiKeys.apiKey)&page=1"
            } else {url = "\(Constants.url)\(movieType.rawValue)&api_key=\(ApiKeys.apiKey)&page=1"}
        }
    }
    private lazy var url = "\(Constants.url)\(movieType.rawValue)&api_key=\(ApiKeys.apiKey)&page=1"
    private var searchMoive = ""

    func getVideo(movieID: Int, completion: @escaping (VideoListViewModel) -> Void) {
        self.movieID = String(movieID)
        guard let url = URL(string: "\(Constants.url)\(movieID)\(Type.video.rawValue)&api_key=\(ApiKeys.apiKey)") else {return}
        let resource = Resource<VideoData>(url: url)
        Webservice.load(resource: resource) { result in
            switch result {
            case .success(let videos):
                completion(VideoListViewModel(data: videos))
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchSimilars(movieID: Int, completion: @escaping (MovieListViewModel) -> Void) {
        self.movieID = String(movieID)
        self.movieType = .similar
        fetchMovies(type: .similar) { movies in
            completion(movies)
        }
    }

    func searchMoives(name: String, completion: @escaping (MovieListViewModel) -> Void) {
        searchMoive = name
        movieType = .search
        guard let url = URL(string: url) else {return}
        let resource = Resource<MovieData>(url: url)
        Webservice.load(resource: resource) { result in
            switch result {
            case .success(let movies):
                completion(MovieListViewModel(data: movies))
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchNextPage(_ page: Int, type: Type, completion: @escaping (MovieListViewModel) -> Void) {
        movieType = type
        guard let url = URL(string: "\(url)&page=\(page)") else {return}
        let resource = Resource<MovieData>(url: url)
        Webservice.load(resource: resource) { result in
            switch result {
            case .success(let movies):
                completion(MovieListViewModel(data: movies))
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchMovies(type: Type = .topRated, completion: @escaping (MovieListViewModel) -> Void) {
        movieType = type
        guard let url = URL(string: "\(url)") else {return}
        let resource = Resource<MovieData>(url: url)
        Webservice.load(resource: resource) { result in
            switch result {
            case .success(let movies):
                completion(MovieListViewModel(data: movies))
            case .failure(let error):
                print(error)
            }
        }
    }
}
