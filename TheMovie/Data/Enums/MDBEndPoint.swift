//
//  MDBEndPoint.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

enum MDBEndPoint {
    
    case sliderMovies(pageNo: Int = 1)
    case popular(pageNo: Int = 1, type: MovieType)
    case genres
    case showcaseMovies(pageNo: Int = 1)
    case actors(pageNo: Int = 1)
    case searchMovies(query: String)
    
    case movieDetail(id: Int, type: MovieType)
    case movieTrailer(id: Int, type: MovieType)
    case movieActors(id: Int, type: MovieType)
    
    case actorDetail(id: Int)
    case actorMovies(id: Int)
    
    var urlString: String {
        get {
            switch self {
            case .sliderMovies(let page):
                return "\(baseURL)/movie/upcoming?api_key=\(apiKey)&page=\(page)"
            case .popular(let page, let type):
                return "\(baseURL)/\(type.rawValue)/popular?api_key=\(apiKey)&page=\(page)"
            case .genres:
                return "\(baseURL)/genre/movie/list?api_key=\(apiKey)"
            case .showcaseMovies(let page):
                return "\(baseURL)/movie/top_rated?api_key=\(apiKey)&page=\(page)"
            case .actors(let page):
                return "\(baseURL)/person/popular?api_key=\(apiKey)&page=\(page)"
            case .searchMovies(let query):
                return "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query)"
            
            case .movieDetail(let id, let type):
                return "\(baseURL)/\(type.rawValue)/\(id)?api_key=\(apiKey)"
            case .movieTrailer(let id, let type):
                return "\(baseURL)/\(type.rawValue)/\(id)/videos?api_key=\(apiKey)"
            case .movieActors(let id, let type):
                return "\(baseURL)/\(type.rawValue)/\(id)/credits?api_key=\(apiKey)"
                
            case .actorDetail(let id):
                return "\(baseURL)/person/\(id)?api_key=\(apiKey)"
            case .actorMovies(let id):
                return "\(baseURL)/person/\(id)/combined_credits?api_key=\(apiKey)"
            }
        }
    }
    
}

enum MovieType: String {
    case movie = "movie"
    case series = "tv"
}
