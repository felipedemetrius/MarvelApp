//
//  NetworkError.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

public enum NetworkErrorCases: Swift.Error {
    case unexpectedValuesRepresentation
    case invalidData
    case error(NetworkError)
}

struct NetworkErrorResponse: Decodable {
    let code, message: String?
}

public struct NetworkError: Hashable, Equatable {
    public let code, message: String
    init(response: NetworkErrorResponse?) {
        self.code = response?.code.orEmpty ?? ""
        self.message = response?.message.orEmpty ?? ""
    }
}

public final class NetworkErrorMapper {
        
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> NetworkError {
        guard let root = try? JSONDecoder().decode(NetworkErrorResponse.self, from: data) else {
            throw NetworkErrorCases.invalidData
        }
        
        return NetworkError(response: root)
    }
}
