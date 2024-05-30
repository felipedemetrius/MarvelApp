//
//  Logger.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

class Logger {
    static let shared = Logger()
    
    private init() {}
    
    func log(url: URLRequest) {
        print("\n[RESQUEST]: URL: \(url.url?.absoluteString ?? "") Method: [\(String(describing: url.httpMethod.orEmpty))] Headers: \(String(describing: url.allHTTPHeaderFields)) Body: \(url.httpBody.toString)\n")
    }
    
    func log(data: Data, response: HTTPURLResponse) {
        print("\n[RESPONSE]: " + response.debugDescription)
        print("[RESPONSE DATA]: \(data.toString)\n")
    }
    
    func log(error: Error) {
        print("\n[ERROR]: " + error.localizedDescription)
    }
}
