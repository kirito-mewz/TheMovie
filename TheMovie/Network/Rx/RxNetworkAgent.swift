//
//  RxNetworkAgent.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift

protocol RxNetworkAgent {
    
    // MARK: - Main
    func fetchMovies(withEndpoint endpoint: MDBEndPoint) -> Observable<MovieResponse>
    func fetchGenres(withEndpoint endpoint: MDBEndPoint) -> Observable<[Genre]>
    func fetchShowcaseMovies(withEndpoint endpoint: MDBEndPoint) -> Observable<MovieResponse>
    func fetchActors(withEndpoint endpoint: MDBEndPoint) -> Observable<ActorResponse>
//    func fetchSearchMovies(with query: String, page: Int) -> Observable<MovieResponse>
    
    // MARK: - Movie Detail
    func fetchMovieDetail(movieId id: Int, type: MovieType) -> Observable<MovieDetailResponse>
    func fetchMovieTrailer(movieId id: Int, type: MovieType) -> Observable<Trailer>
    func fetchMovieActors(movidId id: Int, type: MovieType) -> Observable<[Actor]>
    func fetchSimilarMovies(movieId id: Int, type: MovieType) -> Observable<MovieResponse>
  
    // MARK: - Actor Detail
    func fetchActorDetail(actorId id: Int) -> Observable<ActorDetailResponse>
    func fetchActorMovies(actorId id: Int) -> Observable<ActorCreditResponse>
    
}
