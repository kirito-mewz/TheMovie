//
//  ProductionCompanyObject.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

class ProductionCompanyEmbeddedObject: EmbeddedObject {
    @Persisted var id: Int?
    @Persisted var logoPath: String?
    @Persisted var name: String?
    @Persisted var originCountry: String?
    
    func convertToProductionCompany() -> ProductionCompany {
        ProductionCompany(id: id, logoPath: logoPath, name: name, originCountry: originCountry)
    }
}
