//
//  GenreModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

protocol GenreModel {
    
    func getGenres(completion: @escaping (Result<[Genre], Error>) -> Void)
    
}

final class GenreModelImpl: BaseModel, GenreModel {
    
    static let shared: GenreModel = GenreModelImpl()
    
    private override init() { }
    
    func getGenres(completion: @escaping (Result<[Genre], any Error>) -> Void) {
        networkAgent.fetchGenres(withEndpoint: .genres) { result in
            do {
                let genres = try result.get()
                completion(.success(genres))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
