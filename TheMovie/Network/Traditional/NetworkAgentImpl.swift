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
    
    // MARK: - Main
    func fetchMovies(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
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
        }.validate(statusCode: 200..<300)
    }
    
    func fetchShowcaseMovies(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
        AF.request(endpoint.urlString).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchActors(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<ActorResponse, any Error>) -> Void) {
        AF.request(endpoint.urlString).responseDecodable(of: ActorResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchSearchMovies(with query: String, page: Int, completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
        let urlString = MDBEndPoint.searchMovies(query: query).urlString
        AF.request(urlString).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    // MARK: - Movie Detail
    func fetchMovieDetail(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieDetailResponse, any Error>) -> Void) {
        let urlString = MDBEndPoint.movieDetail(id: id, type: type).urlString
        AF.request(urlString).responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchMovieTrailer(movieId id: Int, type: MovieType, _ completion: @escaping (Result<Trailer, any Error>) -> Void) {
        let urlString = MDBEndPoint.movieTrailer(id: id, type: type).urlString
        AF.request(urlString).responseDecodable(of: MovieTrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                if let trailer = data.results?.first {
                    completion(.success(trailer))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchMovieActors(movidId id: Int, type: MovieType, _ completion: @escaping (Result<[Actor], any Error>) -> Void) {
        let urlString = MDBEndPoint.movieActors(id: id, type: type).urlString
        AF.request(urlString).responseDecodable(of: MovieCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.convertToActor() ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchSimilarMovies(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
        let urlString = MDBEndPoint.similarMovies(id: id, type: type).urlString
        AF.request(urlString).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    // MARK: - Actor Detail
    func fetchActorDetail(actorId id: Int, _ completion: @escaping(Result<ActorDetailResponse, Error>) -> Void) {
        let urlString = MDBEndPoint.actorDetail(id: id).urlString
        AF.request(urlString).responseDecodable(of: ActorDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
    func fetchActorMovies(actorId id: Int,_ completion: @escaping (Result<ActorCreditResponse, Error>) -> Void) {
        let urlString = MDBEndPoint.actorMovies(id: id).urlString
        AF.request(urlString).responseDecodable(of: ActorCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.validate(statusCode: 200..<300)
    }
    
}
