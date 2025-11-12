//
//  NetworkAgentImpl.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Alamofire

final class NetworkAgentImpl: NetworkAgent {
    
    static let shared: NetworkAgentImpl = NetworkAgentImpl()
    
    private init() {}
    
    func fetchMovies(withEndpoint endpoint: MDBEndPoint, completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
        AF.request(endpoint.urlString).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchGenres(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<[Genre], any Error>) -> Void) {
        AF.request(endpoint.urlString).responseDecodable(of: MovieGenres.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.genres ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    func fetchShowcaseMovies(withEndpoint endpoint: MDBEndPoint, page: Int, completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func fetchActors(withEndpoint endpoint: MDBEndPoint, page: Int, completion: @escaping (Result<ActorResponse, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func fetchSearchMovies(with query: String, page: Int, completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
//        <#code#>
//    }
//    
    
    
    
}
