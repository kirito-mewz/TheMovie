//
//  ActorObject.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

class ActorObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var gender: Int?
    @Persisted var movies: List<MovieObject>
    @Persisted var role: String?
    @Persisted var name: String?
    @Persisted var popularity: Double?
    @Persisted var profilePath: String?
    @Persisted var detail: ActorDetailEmbeddedObject?
    @Persisted var pageNo: Int?
    
    func convertToActor() -> Actor {
        Actor(gender: gender,
              id: id,
              movies: movies.map { $0.convertToMovie() },
              role: role,
              name: name,
              popularity: popularity,
              profilePath: profilePath)
    }
}

class ActorDetailEmbeddedObject: EmbeddedObject {
    @Persisted var id: Int?
    @Persisted var birthday: String?
    @Persisted var knownForDepartment: String?
    @Persisted var deathday: String?
    @Persisted var name: String?
    @Persisted var alsoKnownAs: List<String>
    @Persisted var gender: Int?
    @Persisted var biography: String?
    @Persisted var popularity: Double?
    @Persisted var placeOfBirth: String?
    @Persisted var profilePath: String?
    @Persisted var adult: Bool?
    @Persisted var imdbId: String?
    @Persisted var homepage: String?
    
    func convertToActorDetail() -> ActorDetailResponse {
        ActorDetailResponse(birthday: birthday,
                            knownForDepartment: knownForDepartment,
                            deathday: deathday,
                            id: id,
                            name: name,
                            alsoKnownAs: alsoKnownAs.map { String($0) },
                            gender: gender,
                            biography: biography,
                            popularity: popularity,
                            placeOfBirth: placeOfBirth,
                            profilePath: profilePath,
                            adult: adult,
                            imdbId: imdbId,
                            homepage: homepage)
    }
}
