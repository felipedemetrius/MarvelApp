//
//  FeedImageCacheDecorator.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import Foundation
import FeatureFeed

public final class FeedImageDataLoaderCacheDecorator: ImageDataLoader {
    private let decoratee: ImageDataLoader
    private let cache: CharacterDataImageCache

    public init(decoratee: ImageDataLoader, cache: CharacterDataImageCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    public func loadImageData(from url: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.saveIgnoringResult(data, for: url.url!)
                return data
            })
        }
    }
}

private extension CharacterDataImageCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        try? save(data, for: url)
    }
}
