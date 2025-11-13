//
//  ActorRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

protocol ActorRepository {
    
    func saveActors(page: Int, actors: [Actor])
    func getActors(page: Int, _ completion: @escaping ([Actor]) -> Void)
    
    func saveActorDetail(actorId id: Int, detail: ActorDetailResponse)
    func getActorDetail(actorId id: Int, _ completion: @escaping(ActorDetailResponse?) -> Void)
    
}
 
final class ActorRepositoryImpl: BaseRepository, ActorRepository {
    
    static let shared = ActorRepositoryImpl()
    
    override init() { }
    
    func saveActors(page: Int, actors: [Actor]) {
        do {
            let obj = actors.map { $0.convertToActorObject(pageNo: page) }
            try realm.write { realm.add(obj, update: .modified) }
        } catch {
            print("\(#function) \(error)")
        }
    }
    
    func getActors(page: Int, _ completion: @escaping ([Actor]) -> Void) {
        let predicate = NSPredicate(format: "pageNo = %d", page)
        let objects: Results<ActorObject> = realm.objects(ActorObject.self).filter(predicate)
        completion(objects.map { $0.convertToActor() } )
    }
    
    func saveActorDetail(actorId id: Int, detail: ActorDetailResponse) {
        findActorById(id) { [weak self] actor in
            guard let self = self, let actor = actor else { return }
            do {
                let embeddedDetail = detail.convertToActorDetailEmbeddedObj()
                try self.realm.write {
                    actor.detail = embeddedDetail
                    self.realm.add(actor, update: .modified)
                }
            } catch {
                print("\(#function) \(error)")
            }
        }
    }
    
    func getActorDetail(actorId id: Int, _ completion: @escaping(ActorDetailResponse?) -> Void) {
        if let obj = realm.object(ofType: ActorObject.self, forPrimaryKey: id)?.detail {
            completion(obj.convertToActorDetail())
        } else {
            completion(nil)
        }
    }
    
    private func findActorById(_ id: Int, completion: @escaping (ActorObject?) -> Void) {
        completion(realm.object(ofType: ActorObject.self, forPrimaryKey: id))
    }
    
}
