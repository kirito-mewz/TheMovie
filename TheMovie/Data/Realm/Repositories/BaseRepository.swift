//
//  BaseRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

class BaseRepository {

    let realm: Realm

    init() {
        // Create your own stable folder inside Documents
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let realmFolder = documentsURL.appendingPathComponent("RealmDB")

        // Create folder if missing
        if !FileManager.default.fileExists(atPath: realmFolder.path) {
            do {
                try FileManager.default.createDirectory(at: realmFolder, withIntermediateDirectories: true)
            } catch {
                fatalError("Failed to create RealmDB folder: \(error)")
            }
        }

        // Point Realm to a custom file inside the folder
        let realmFileURL = realmFolder.appendingPathComponent("themovie.realm")

        let config = Realm.Configuration(
            fileURL: realmFileURL,
            deleteRealmIfMigrationNeeded: true
        )

        Realm.Configuration.defaultConfiguration = config

        // Now Realm will always succeed
        do {
            realm = try Realm()
            print("Default Realm file location: \(realm.configuration.fileURL?.absoluteString ?? "undefined")")
        } catch {
            fatalError("REALM FAILED: \(error)")
        }
    }
}
