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
    private let repo: GenreRepository = GenreRepositoryImpl.shared
    
    private override init() { }
    
    func getGenres(completion: @escaping (Result<[Genre], any Error>) -> Void) {
        networkAgent.fetchGenres(withEndpoint: .genres) { [weak self] result in
            do {
                let response = try result.get()
                self?.repo.saveGenres(genres: response)
                
                self?.repo.getGenres { completion(.success($0)) }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
