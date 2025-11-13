//
//  ProductionCountryObject.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

class ProductionCountryEmbeddedObject: EmbeddedObject {
    @Persisted var name: String?
    @Persisted var iso3166_1: String?
    
    func convertToProductionCountry() -> ProductionCountry {
        ProductionCountry(iso3166_1: iso3166_1, name: name)
    }
}
