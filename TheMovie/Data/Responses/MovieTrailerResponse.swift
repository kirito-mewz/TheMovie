//
//  MovieTrailerResponse.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

// MARK: - MovieTrailerResponse
struct MovieTrailerResponse: Codable {
    let id: Int?
    let results: [Trailer]?
}

// MARK: - Result
struct Trailer: Codable {
    let id, iso639_1, iso3166_1, keyPath: String?
    let name, site: String?
    let size: Int?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case keyPath = "key"
        case name, site, size, type
    }
}
