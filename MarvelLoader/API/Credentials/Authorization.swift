//
//  Authorization.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

struct Authorization {
    static let PublicKey = "4ba890814dc8ad862ce524a387d0fa36"
    static let PrivateKey = "119992e520824e288bc2b1f1fd454689a43ddd7e"
    
    static func credentials() -> [String: Any] {
        let randonTimeStamp = Int.random(min: 100, max: 300)
        let hash = Encrypt.toMD5(string: randonTimeStamp.description + Authorization.PrivateKey + Authorization.PublicKey)

        var parameters: [String: Any] = [:]
        parameters["ts"] = randonTimeStamp.description
        parameters["apikey"] = Authorization.PublicKey
        parameters["hash"] = hash
        parameters["limit"] = "10"
        return parameters
    }
}
