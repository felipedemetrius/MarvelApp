//
//  CharactersEndpoint.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

public enum CharactersEndpoint {
    case get(page: Int)
    
    public func url(baseURL: URL) -> URLRequest {
        switch self {
        case .get(let page):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/public/characters"
            var authorization = Authorization.credentials()
                .map(
                    { URLQueryItem(name: $0.key, value: $0.value as? String) }
                ).compactMap { $0 }
            
            authorization.append(URLQueryItem(name: "offset", value: page.description))
            
            components.queryItems = authorization
            
            let request = URLRequest(url: components.url!)
            return request
        }
    }
}
