//
//  ActorCreditResponse.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

struct ActorCreditResponse: Codable {
    var movies: [MovieDetailResponse]?
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case movies = "cast"
    }
}
