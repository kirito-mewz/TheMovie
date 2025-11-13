//
//  ActorResponse.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import RealmSwift

// MARK: - ActorResponse
struct ActorResponse: Codable {
    let page: Int?
    let results: [Actor]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Actor
struct Actor: Codable {
    let gender: Int?
    let id: Int?
    let movies: [Movie]?
    let role: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case gender
        case id
        case movies = "known_for"
        case role = "known_for_department"
        case name
        case popularity
        case profilePath = "profile_path"
    }
    
    func convertToActorObject(pageNo: Int) -> ActorObject {
        let obj = ActorObject()
        
        let movieObjs = List<MovieObject>()
        movies?.map { $0.convertToMovieObj(type: .others) }.forEach { movieObjs.append($0) }
        
        obj.gender = gender
        obj.id = id ?? 0
        obj.movies = movieObjs
        obj.role = role
        obj.name = name
        obj.popularity = popularity
        obj.profilePath = profilePath
        obj.pageNo = pageNo
        return obj
    }
}
