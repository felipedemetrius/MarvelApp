//
//  CharactersEndpoint.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

enum CharactersEndpoint {
    case get(page: Int)
    
    func url(path: Endpoints.Paths) -> URLRequest {
        switch self {
        case .get(let page):
            let url = URLComponents.makeURL(path: .characters, page: page)
            let request = URLRequest(url: url)
            return request
        }
    }
}
