//
//  CollectionViewController.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/23/21.
//

import UIKit
import MBProgressHUD

class MovieCollectionViewController: UICollectionViewController {

    @IBOutlet weak var filterMoviesButton: UIBarButtonItem!

    private var topRefreshControl = UIRefreshControl()
    private var bottomRefreshControll = UIRefreshControl()
    private var service = ApiCall.shared
    private var movies: MovieListViewModel!
    private var filterView: CustomFilterView!
    private var typeOfMovie = Type.topRated
    private var refreshing = false
    private var typeChanged = true
    private var index = 0
    private var movieDataSource: CollectionViewDataSource<MovieCell, MovieViewModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        fetchMovies()
        configCollectionView()
        configSearch()
        configFilterView()
        configRefresh()
        self.navigationItem.title = typeOfMovie.stringValue
    }

    private func configRefresh() {
        topRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        topRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = topRefreshControl
    }

    private func configSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func configFilterView() {
        self.filterMoviesButton.action = #selector(filterMenu(_:))
        self.filterMoviesButton.target = self
        filterView = CustomFilterView(frame: super.view.frame)
        filterView.delegate = self
        filterView.datasource = Type.allCases[0...3].map({$0})
        self.view.addSubview(filterView)
    }

    private func configCollectionView() {
        collectionView.register(UINib(nibName: Constants.movieCell, bundle: nil), forCellWithReuseIdentifier: Constants.movieCell)

        self.movieDataSource = CollectionViewDataSource(cellIdentifier: Constants.movieCell, item: []) {cell, viewM in
            cell.movie = viewM
            cell.favDelegate = self
        }
        self.collectionView.dataSource = self.movieDataSource
        self.collectionView.delegate = self

    }

    private func fetchMovies() {
        if !Network.reachability.isReachable {return}
        if typeChanged || refreshing {
            index = 0
            MBProgressHUD.showAdded(to: self.view, animated: true)
            service.fetchMovies(type: typeOfMovie) { [self] movies in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.movies = movies
                self.movies?.checkFavourite()
                self.movieDataSource.updateItem(self.movies!.movies)

                let indexPath = self.movies?.indexPaths(index)
                if !refreshing {
                    collectionView.insertItems(at: indexPath!)
                } else {
                    collectionView.reloadData()
                    refreshing = false
                }
                typeChanged = false
                index = self.movies!.numberOfRows
            }
        } else {
            if movies?.nextPage == movies?.totalPages { return}
            service.fetchNextPage(movies!.nextPage, type: typeOfMovie) { [self] mov in
                self.movies?.addMovies(mov)
                self.movies?.checkFavourite()
                self.movieDataSource.appendItem(mov.movies)
                collectionView.insertItems(at: movies!.indexPaths(index))
                index = movies!.numberOfRows
            }
        }
    }

}

// MARK: Actions
extension MovieCollectionViewController {

    @objc func refresh(_ sender: UIRefreshControl) {
        topRefreshControl.endRefreshing()
        if typeOfMovie == .favourites || typeOfMovie == .search { return}
        refreshing = true
        fetchMovies()
    }

    @objc func filterMenu(_ sender: UIBarButtonItem) {
        filterView.showFilter()
    }

}

// MARK: Delegate Methods Filter, Favourites
extension MovieCollectionViewController: Favourites, FilterMovies {

    func filter(type: Type) {
        typeOfMovie = type
        self.collectionView.setContentOffset(.zero, animated: true)
        movies = nil
        self.movieDataSource.updateItem([])
        self.navigationItem.title = type.stringValue
        collectionView.reloadData()
        self.typeChanged = true
        if type == .favourites {
            self.movies = MovieListViewModel(Dbase.shared.getMovies())
            self.movieDataSource.updateItem(self.movies!.movies)
            return
        }
        self.fetchMovies()
    }

    func addToFavourite(_ movie: MovieViewModel) {
        movies?.addFavourite(movie)
        if let indexFor = movies?.indexOfMovie(movie) {
            collectionView.reloadItems(at: [IndexPath(row: indexFor, section: 0)])
        }
    }

    func removeFavourite(_ movie: MovieViewModel) {
        self.movies?.removeFavourite(movie)
        if let index = movies?.indexOfMovie(movie) {
            if typeOfMovie == .favourites {
                movies?.removeMovie(at: index)
                self.movieDataSource.removeItem(at: index)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            } else {
                collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }

        }
    }
}

// MARK: Search Logic
extension MovieCollectionViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let name = searchController.searchBar.text?.replacingOccurrences(of: " ", with: "%20")
        if name == "" {return}
        self.navigationItem.title = "Results For: \(searchController.searchBar.text!)"
        self.collectionView.setContentOffset(.zero, animated: true)
        searchMovies(name!)
    }

    private func searchMovies(_ name: String) {
        if !Network.reachability.isReachable {return}
        service.searchMoives(name: name) { [self] movie in
            typeOfMovie = .search
            index = 0
            movies = movie
            self.movies?.checkFavourite()
            self.movieDataSource.updateItem(self.movies!.movies)
            collectionView.reloadData()
            typeChanged = false
            index = movies!.numberOfRows
        }
    }
}

// MARK: CollectionView Layout
extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.detailsVC) as DetailsViewController
        viewC.movie = self.movieDataSource.item[indexPath.row]
        viewC.favDelegate = self
        self.navigationController?.pushViewController(viewC, animated: true)

    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.movieDataSource.item.count - 10 ), typeOfMovie != .favourites {
            self.fetchMovies()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/2.02, height: collectionViewWidth/1.4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
