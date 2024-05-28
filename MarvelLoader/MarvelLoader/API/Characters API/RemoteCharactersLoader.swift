//
//  RemoteCharactersLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Combine

public protocol RemoteCharactersLoader {
    func get(page: Int) -> AnyPublisher<[Character], Error>
}

public final class RemoteCharactersLoaderImpl: RemoteCharactersLoader {
    
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    public func get(page: Int = 0) -> AnyPublisher<[Character], any Error> {
        let url = CharactersEndpoint.get(page: page)
            .url(baseURL: Authorization.baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(CharactersMapper.map)
            .eraseToAnyPublisher()
    }
}
