//
//  URLComponents+Extension.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

extension URLComponents {
    static func makeURL(path: Endpoints.Paths, page: Int? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Endpoints.baseURL.scheme
        components.host = Endpoints.baseURL.host
        components.path = Endpoints.baseURL.path + path.rawValue
        var authorization = Authorization.credentials()
            .map(
                { URLQueryItem(name: $0.key, value: $0.value as? String) }
            ).compactMap { $0 }
        
        if let page {
            authorization.append(URLQueryItem(name: "offset", value: page.description))
        }
        
        components.queryItems = authorization
        return components.url!
    }
}
