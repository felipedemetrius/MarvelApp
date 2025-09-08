//
//  CharacterImageDataLoaderWithFallbackComposite.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import Foundation
import FeatureFeed

public class CharacterImageDataLoaderWithFallbackComposite: ImageDataLoader {
    private let primary: ImageDataLoader
    private let fallback: ImageDataLoader

    public init(primary: ImageDataLoader, fallback: ImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    private class TaskWrapper: ImageDataLoaderTask {
        var wrapped: ImageDataLoaderTask?

        func cancel() {
            wrapped?.cancel()
        }
    }

    public func loadImageData(from url: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)

            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }

        }
        return task
    }
}
