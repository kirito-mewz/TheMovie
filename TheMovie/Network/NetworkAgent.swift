//
//  NetworkAgent.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Alamofire

protocol NetworkAgent {
    
    // MARK: - Main
    func fetchMovies(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func fetchGenres(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<[Genre], Error>) -> Void)
    func fetchShowcaseMovies(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func fetchActors(withEndpoint endpoint: MDBEndPoint, _ completion: @escaping (Result<ActorResponse, Error>) -> Void)
    func fetchSearchMovies(with query: String, page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void)
    
    // MARK: - Movie Detail
    func fetchMovieDetail(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieDetailResponse, Error>) -> Void)
    func fetchMovieTrailer(movieId id: Int, type: MovieType, _ completion: @escaping (Result<Trailer, Error>) -> Void)
    func fetchMovieActors(movidId id: Int, type: MovieType, _ completion: @escaping (Result<[Actor], Error>) -> Void)
    func fetchSimilarMovies(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
  
    // MARK: - Actor Detail
    func fetchActorDetail(actorId id: Int, _ completion: @escaping(Result<ActorDetailResponse, Error>) -> Void)
    func fetchActorMovies(actorId id: Int,_ completion: @escaping (Result<ActorCreditResponse, Error>) -> Void)
    
}
