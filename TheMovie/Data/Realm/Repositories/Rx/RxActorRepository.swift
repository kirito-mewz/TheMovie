//
//  RxActorRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift
import RxRealm
import RealmSwift

protocol RxActorRepository {
    
    func saveActors(page: Int, actors: [Actor])
    func getActors(page: Int) -> Observable<[Actor]>
    
    func saveActorDetail(actorId id: Int, detail: ActorDetailResponse)
    func getActorDetail(actorId id: Int) -> Observable<ActorDetailResponse>
}

final class RxActorRepositoryImpl: BaseRepository, RxActorRepository {
    
    static let shared: RxActorRepository = RxActorRepositoryImpl()
    
    private var disposeBag = DisposeBag()
    
    override init() { }
    
    func saveActors(page: Int, actors: [Actor]) {
        let obj = actors.map { $0.convertToActorObject(pageNo: page) }
        Observable.from(obj)
            .subscribe(realm.rx.add(update: .modified))
            .disposed(by: disposeBag)
    }
    
    func getActors(page: Int) -> RxSwift.Observable<[Actor]> {
        let predicate = NSPredicate(format: "pageNo = %d", page)
        let collection: Results<ActorObject> = realm.objects(ActorObject.self).filter(predicate)
        
        return Observable.collection(from: collection)
            .flatMap { objects -> Observable<[Actor]> in
                Observable.of(objects.map { $0.convertToActor() } )
            }
    }
   
    func saveActorDetail(actorId id: Int, detail: ActorDetailResponse) {
        if let object = realm.object(ofType: ActorObject.self, forPrimaryKey: id) {
            try? realm.write {
                object.detail = detail.convertToActorDetailEmbeddedObj()
            }
        } else {
            let obj = ActorObject()
            obj.id = detail.id ?? -1
            obj.detail = detail.convertToActorDetailEmbeddedObj()
            
            try? realm.write {
                realm.add(obj, update: .modified)
            }
        }
    }
    
    func getActorDetail(actorId id: Int) -> RxSwift.Observable<ActorDetailResponse> {
        let object = realm.object(ofType: ActorObject.self, forPrimaryKey: id)!
        return Observable.of((object.detail?.convertToActorDetail())!)
    }
    
    
}
