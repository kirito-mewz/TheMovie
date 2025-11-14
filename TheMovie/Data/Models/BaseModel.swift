//
//  BaseModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 12/11/2025.
//

import Foundation

class BaseModel {
    
    let networkAgent: NetworkAgent = NetworkAgentImpl.shared
    let rxNetworkAgent: RxNetworkAgent = RxNetworkAgentImpl.shared
    
}
