//
//  RemoteCharactersLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Combine

public protocol RemoteCharactersLoader {
    func get(page: Int) -> AnyPublisher<[Character], NetworkErrorCases>
}

public final class RemoteCharactersLoaderImpl: RemoteCharactersLoader {
    
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    public func get(page: Int = 0) -> AnyPublisher<[Character], NetworkErrorCases> {
        let url = CharactersEndpoint.get(page: page)
            .url(path: .characters)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(CharactersMapper.map)
            .mapNetworkError()
            .eraseToAnyPublisher()
    }
}
