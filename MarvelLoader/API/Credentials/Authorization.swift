//
//  Authorization.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

struct Authorization {
    static let PublicKey = "42450c7c30ed07da81c79ddcb929343a"
    static let PrivateKey = "92b20d8b768c02a6be7c48ecb568aa60c623e7f7"
    
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
