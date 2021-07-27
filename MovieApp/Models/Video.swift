//
//  Video.swift
//  MovieApp
//
//  Created by George Digmelashvili on 7/10/21.
//

import Foundation
struct VideoData: Codable {
    let id: Int?
    let results: [Video]
}

// MARK: - Result
struct Video: Codable {
    let id, iso639_1, iso3166_1, key: String
    let name, site: String
    let size: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }
}
