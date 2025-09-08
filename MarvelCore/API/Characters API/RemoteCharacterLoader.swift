//
//  RemoteCharacterLoader.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import Foundation
import FeatureFeed

public final class RemoteCharacterLoader: CharacterLoader {
    private let url: URLRequest
    private let client: HTTPClient

    public init(url: URLRequest, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        client.load(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, httpResponse)):
                do {
                    let results = try CharactersMapper.map(data, from: httpResponse)
                    completion(.success(results))
                } catch {
                    completion(.failure(NetworkErrorCases.invalidData))
                }
            case .failure:
                completion(.failure(NetworkErrorCases.invalidData))
            }
        }
    }
}
