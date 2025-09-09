//
//  FeedLoaderCacheDecorator.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import FeatureFeed

public final class FeedLoaderCacheDecorator: CharacterLoader {
    private let decoratee: CharacterLoader
    private let cache: CharacterCache

    public init(decoratee: CharacterLoader, cache: CharacterCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    public func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }
}

private extension CharacterCache {
    func saveIgnoringResult(_ feed: [Character]) {
        try? save(feed)
    }
}
