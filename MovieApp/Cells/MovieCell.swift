//
//  MovieCell.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/12/21.
//

import UIKit

protocol Favourites {
    func addToFavourite(_ movie: MovieViewModel)
    func removeFavourite(_ movie: MovieViewModel)
}

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    private lazy var ratingV = CustomRatingView(frame: ratingView.bounds)
    var favDelegate: Favourites?
    
    var movie: MovieViewModel! {
        didSet{
            favImg()
            ratingV.rating = movie.voteAverage
            ratingView.addSubview(ratingV)
            if let img = movie.poster{
                self.imageView.image = img
            } else{
                movie.posterPath.downloadImage { img in
                    self.imageView.image = img
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
        
    }
    
    @IBAction func favouriteButtonClick(_ sender: UIButton) {
        self.movie.isFavourite.toggle()
        favImg()
        if self.movie.isFavourite{
            self.movie.poster = imageView.image
            favDelegate?.addToFavourite(self.movie)
        } else{
            favDelegate?.removeFavourite(self.movie)
        }
    }
    
    private func favImg(){
        let img = movie.isFavourite ? UIImage(named: "star.fill") : UIImage(named: "star")
        self.favouriteButton.setImage(img, for: .normal)
    }
    
}
