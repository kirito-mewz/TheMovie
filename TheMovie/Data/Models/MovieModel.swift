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
    
    
}
