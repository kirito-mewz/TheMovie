//
//  ActorModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

protocol ActorModel {
    
    func getActor(pageNo: Int?, completion: @escaping (Result<ActorResponse, Error>) -> Void)
    
}

final class ActorModelImpl: BaseModel, ActorModel {
    
    static let shared: ActorModel = ActorModelImpl()
    
    private override init() { }
    
    func getActor(pageNo: Int?, completion: @escaping (Result<ActorResponse, Error>) -> Void) {
        networkAgent.fetchActors(withEndpoint: .actors(pageNo: pageNo ?? 1)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
