//
//  VideoCell.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/14/21.
//

import UIKit
import youtube_ios_player_helper

class VideoCell: UICollectionViewCell {

    @IBOutlet weak var videoView: YTPlayerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupVideo(_ video: VideoViewModel) {
        videoView.load(withVideoId: video.key)
    }

}
