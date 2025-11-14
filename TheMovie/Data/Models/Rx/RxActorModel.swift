//
//  RxActorModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift

protocol RxActorModel {
    
    func getActors(pageNo: Int?) -> Observable<ActorResponse>
    func getActorDetail(actorId id: Int) -> Observable<ActorDetailResponse>
    func getActorMovies(actorId id: Int) -> Observable<ActorCreditResponse>
    
}

final class RxActorModelImpl: BaseModel, RxActorModel {
 
    static let shared: RxActorModel = RxActorModelImpl()
    private let rxRepo: RxActorRepository = RxActorRepositoryImpl.shared
    
    private override init() { }
    
    func getActors(pageNo: Int?) -> RxSwift.Observable<ActorResponse> {
        rxNetworkAgent.fetchActors(withEndpoint: .actors(pageNo: pageNo ?? 1))
            .do { [weak self] response in
                self?.rxRepo.saveActors(page: pageNo ?? 1, actors: response.results ?? [])
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response in
                self.rxRepo.getActors(page: pageNo ?? 1)
                    .flatMap { actors in
                        return Observable.of(ActorResponse(page: response.page, results: actors, totalPages: response.totalPages, totalResults: response.totalResults))
                    }
                
            }
    }
    
    func getActorDetail(actorId id: Int) -> RxSwift.Observable<ActorDetailResponse> {
        rxNetworkAgent.fetchActorDetail(actorId: id)
            .do { [weak self] response in
                self?.rxRepo.saveActorDetail(actorId: id, detail: response)
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response in
                self.rxRepo.getActorDetail(actorId: response.id ?? -1)
            }
    }
    
    func getActorMovies(actorId id: Int) -> RxSwift.Observable<ActorCreditResponse> {
        rxNetworkAgent.fetchActorMovies(actorId: id)
    }
    
}
