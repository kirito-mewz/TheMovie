//
//  ActorModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

protocol ActorModel {
    
    func getActors(pageNo: Int?, completion: @escaping (Result<ActorResponse, Error>) -> Void)
    func getActorDetail(actorId id: Int, completion: @escaping (Result<ActorDetailResponse, Error>) -> Void)
    func getActorMovies(actorId id: Int,_ completion: @escaping (Result<ActorCreditResponse, Error>) -> Void)
    
}

final class ActorModelImpl: BaseModel, ActorModel {
    
    static let shared: ActorModel = ActorModelImpl()
    private let repo: ActorRepository = ActorRepositoryImpl.shared
    
    private override init() { }
    
    func getActors(pageNo: Int?, completion: @escaping (Result<ActorResponse, Error>) -> Void) {
        networkAgent.fetchActors(withEndpoint: .actors(pageNo: pageNo ?? 1)) { [weak self] result in
            do {
                let response = try result.get()
                self?.repo.saveActors(page: pageNo ?? 1, actors: response.results ?? [])
                
                self?.repo.getActors(page: pageNo ?? 1) { actors in
                    completion(.success(ActorResponse(page: response.page, results: actors, totalPages: response.totalPages, totalResults: response.totalResults)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getActorDetail(actorId id: Int, completion: @escaping (Result<ActorDetailResponse, Error>) -> Void) {
        networkAgent.fetchActorDetail(actorId: id) { [weak self] result in
            do {
                let response = try result.get()
                self?.repo.saveActorDetail(actorId: id, detail: response)
                
                self?.repo.getActorDetail(actorId: id) { actor in
                    guard let actor = actor else {
                        completion(.success(response))
                        return
                    }
                    completion(.success(actor))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getActorMovies(actorId id: Int,_ completion: @escaping (Result<ActorCreditResponse, Error>) -> Void) {
        networkAgent.fetchActorMovies(actorId: id) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
