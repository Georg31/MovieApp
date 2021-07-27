//
//  VideoViewModel.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/10/21.
//

import Foundation

struct VideoListViewModel {

    var videos = [VideoViewModel]()
    var videoCount: Int {
        return videos.count
    }
    func videoAtIndex(_ index: Int) -> VideoViewModel {
        return self.videos[index]
    }
}

extension VideoListViewModel {

    init(data: VideoData) {
        self.videos = data.results.map({VideoViewModel($0)})
    }
}

struct VideoViewModel {

    private let video: Video
}

extension VideoViewModel {

    init(_ video: Video) {
        self.video = video
    }

    var name: String {
        return video.name
    }

    var type: String {
        return video.type
    }

    var site: String {
        return video.site
    }

    var key: String {
        return video.key
    }
}
