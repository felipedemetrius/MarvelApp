//
//  Data+Extension.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

extension Optional where Wrapped == Data {
    var toString: String {
        if let data = self {
            return String(data: data, encoding: .utf8) ?? "No data"
        }
        return "No data"
    }
}

extension Data {
    var toString: String {
        return String(data: self, encoding: .utf8) ?? "No data"
    }
}
