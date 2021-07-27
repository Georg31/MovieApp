//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/24/21.
//

import UIKit
import youtube_ios_player_helper

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var PosterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionHeight: NSLayoutConstraint!
    
    private var videoDataSource: CollectionViewDataSource<VideoCell,VideoViewModel>!
    private var movieDataSource: CollectionViewDataSource<MovieCell,MovieViewModel>!
    
    private var service = ApiCall.shared
    private var similarMovies: MovieListViewModel?
    private var video: VideoListViewModel?
    var movie: MovieViewModel!
    var favDelegate: Favourites?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        getVideos()
        configView()
        configCollectionView()
        
    }
    
    @IBAction func FavoutriteButton(_ sender: UIButton) {
        movie.isFavourite.toggle()
        if movie.isFavourite{
            sender.setImage(UIImage(named: "star.fill"), for: .normal)
            self.movie.poster = self.PosterImage.image
            favDelegate?.addToFavourite(movie)
        }
        else{
            sender.setImage(UIImage(named: "star"), for: .normal)
            favDelegate?.removeFavourite(movie)
        }
    }
    
    private func configCollectionView(){
        videoCollectionView.register(UINib(nibName: Constants.videoCell, bundle: nil), forCellWithReuseIdentifier: Constants.videoCell)
        collectionView.register(UINib(nibName: Constants.movieCell, bundle: nil), forCellWithReuseIdentifier: Constants.movieCell)
        
        self.movieDataSource = CollectionViewDataSource(cellIdentifier: Constants.movieCell, item: []){cell, vm in
            cell.movie = vm
            cell.favDelegate = self.favDelegate
        }
        
        self.videoDataSource = CollectionViewDataSource(cellIdentifier: Constants.videoCell, item: []){ cell, vm in
            cell.setupVideo(vm)
        }
        collectionView.dataSource = self.movieDataSource
        collectionView.delegate = self
        self.videoCollectionView.dataSource = self.videoDataSource
        self.videoCollectionView.delegate = self
        
        
    }
    
    private func fetchMovies(){
        if !Network.reachability.isReachable{return}
        self.service.fetchSimilars(movieID: movie.id) { [self] mov in
            self.similarMovies = mov
            self.similarMovies?.checkFavourite()
            self.movieDataSource.updateItem(similarMovies!.movies)
            self.collectionView.reloadData()
        }
    }
    
    private func getVideos(){
        if !Network.reachability.isReachable{return}
        service.getVideo(movieID: movie.id) { [self] vid in
            self.video = vid
            self.videoDataSource.updateItem(video!.videos)
            self.videoCollectionView.reloadData()
            if self.video?.videoCount == 0{
                self.videoCollectionHeight.constant = 0
            }
        }
    }
    
    private func configView(){
        let ratingV = CustomRatingView(frame: ratingView.bounds)
        ratingV.rating = movie.voteAverage
        self.ratingView.addSubview(ratingV)
        self.navigationItem.title = movie.originalTitle
        self.titleLabel.text = movie.title
        self.releaseDateLabel.text = movie.releaseDate
        self.descriptionLabel.text = movie.overview
        self.voteCountLabel.text = "Votes: \(movie.voteCount)"
        if movie.isFavourite{
            favouriteButton.setImage(UIImage(named: "star.fill"), for: .normal)
        }
        if let img = self.movie.poster{
            self.PosterImage.image = img
        } else{
            self.movie.posterPath.downloadImage { [self] img in
                PosterImage.image = img
            }
        }
        
    }
    
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailsViewController") as DetailsViewController
        vc.movie = similarMovies?.movieAtIndex(indexPath.row)
        vc.favDelegate = self.favDelegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 3
        let cellHeight = collectionView.bounds.height / 1.02
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension DetailsViewController: YTPlayerViewDelegate{
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            print("bufferring")
        case .cued:
            print("cued")
        case .unstarted:
            print("unstarted")
        case .ended:
            print("ended")
            playerView.stopVideo()
            playerView.removeFromSuperview()
        case .playing:
            print("playing")
        case .paused:
            print("paused")
            playerView.removeFromSuperview()
        case .unknown:
            print("unknown")
        @unknown default:
            print("default")
        }
    }
}
