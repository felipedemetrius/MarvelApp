//
//  Publisher+Extension.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Combine

public extension Publisher {
    func mapNetworkError() -> Publishers.MapError<Self, NetworkErrorCases> {
        mapError(
            { error -> NetworkErrorCases in
                switch (error) {
                case let url_error as NetworkErrorCases:
                    return url_error
                default:
                    return NetworkErrorCases.unexpectedValuesRepresentation
                }
            }
        )
    }
}

