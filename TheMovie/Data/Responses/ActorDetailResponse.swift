//
//  ActorDetailResponse.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import RealmSwift

// MARK: - ActorDetailResponse
struct ActorDetailResponse: Codable {
    let birthday, knownForDepartment: String?
    let deathday: String?
    let id: Int?
    let name: String?
    let alsoKnownAs: [String]?
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let placeOfBirth, profilePath: String?
    let adult: Bool?
    let imdbId: String?
    let homepage: String?
    
    static let emptyObj = ActorDetailResponse(birthday: nil, knownForDepartment: nil, deathday: nil, id: nil, name: nil, alsoKnownAs: nil, gender: nil, biography: nil, popularity: nil, placeOfBirth: nil, profilePath: nil, adult: nil, imdbId: nil, homepage: nil)

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbId = "imdb_id"
        case homepage
    }
    
    func convertToActorDetailEmbeddedObj() -> ActorDetailEmbeddedObject {
        let obj = ActorDetailEmbeddedObject()
        
        let akaList = List<String>()
        alsoKnownAs?.forEach { akaList.append($0) }

        obj.id = id ?? 0
        obj.birthday = birthday
        obj.knownForDepartment = knownForDepartment
        obj.deathday = deathday
        obj.name = name
        obj.alsoKnownAs = akaList
        obj.gender = gender
        obj.biography = biography
        obj.popularity = popularity
        obj.placeOfBirth = placeOfBirth
        obj.profilePath = profilePath
        obj.adult = adult
        obj.imdbId = imdbId
        obj.homepage = homepage
        return obj
    }
}
