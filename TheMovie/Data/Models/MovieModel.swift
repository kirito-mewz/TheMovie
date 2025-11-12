//
//  MovieModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

protocol MovieModel {
    
    func getSliderMovies(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func getPopularMovies(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func getPopularSeries(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func getShowcaseMovies(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func getSearchMovies(query: String, pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
    
    func getMovieDetail(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieDetailResponse, Error>) -> Void)
    func getMovieTrailer(movieId id: Int, type: MovieType, _ completion: @escaping (Result<Trailer, Error>) -> Void)
    func getMovieActors(movieId id: Int, type: MovieType, completion: @escaping (Result<[Actor], Error>) -> Void)
    func getSimilarMovies(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieResponse, Error>) -> Void)
}

final class MovieModelImpl: BaseModel, MovieModel {

    static let shared: MovieModel = MovieModelImpl()
    
    private override init() { }
    
    func getSliderMovies(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkAgent.fetchMovies(withEndpoint: .sliderMovies(pageNo: pageNo ?? 1)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getPopularMovies(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkAgent.fetchMovies(withEndpoint: .popular(pageNo: pageNo ?? 1, type: .movie)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getPopularSeries(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkAgent.fetchMovies(withEndpoint: .popular(pageNo: pageNo ?? 1, type: .series)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getShowcaseMovies(pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkAgent.fetchShowcaseMovies(withEndpoint: .showcaseMovies(pageNo: pageNo ?? 1)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getSearchMovies(query: String, pageNo: Int?, _ completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkAgent.fetchSearchMovies(with: query, page: pageNo ?? 1) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getMovieDetail(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieDetailResponse, Error>) -> Void) {
        networkAgent.fetchMovieDetail(movieId: id, type: type) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getMovieTrailer(movieId id: Int, type: MovieType, _ completion: @escaping (Result<Trailer, Error>) -> Void) {
        networkAgent.fetchMovieTrailer(movieId: id, type: type) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getMovieActors(movieId id: Int, type: MovieType, completion: @escaping (Result<[Actor], Error>) -> Void) {
        networkAgent.fetchMovieActors(movidId: id, type: type) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getSimilarMovies(movieId id: Int, type: MovieType, _ completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        networkAgent.fetchSimilarMovies(movieId: id, type: type) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
