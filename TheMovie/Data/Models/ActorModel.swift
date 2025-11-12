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
    
    private override init() { }
    
    func getActors(pageNo: Int?, completion: @escaping (Result<ActorResponse, Error>) -> Void) {
        networkAgent.fetchActors(withEndpoint: .actors(pageNo: pageNo ?? 1)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getActorDetail(actorId id: Int, completion: @escaping (Result<ActorDetailResponse, Error>) -> Void) {
        networkAgent.fetchActorDetail(actorId: id) { result in
            do {
                let response = try result.get()
                completion(.success(response))
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
