//
//  LocalCharacterImageDataLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import Foundation
import FeatureFeed

public final class LocalCharacterImageDataLoader {
    private let store: CharacterImageDataStore
    
    public init(store: CharacterImageDataStore) {
        self.store = store
    }
}

extension LocalCharacterImageDataLoader: CharacterDataImageCache {
    public enum SaveError: Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}

extension LocalCharacterImageDataLoader: CharacterImageDataLoader {
    public enum LoadError: Error {
        case failed
        case notFound
    }
        
    public func loadImageData(from url: URL) throws -> Data {
        do {
            if let imageData = try store.retrieve(dataForURL: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        
        throw LoadError.notFound
    }
}

extension LocalCharacterImageDataLoader: ImageDataLoader {
        
    private final class TaskWrapper: ImageDataLoaderTask {

        init() {}

        func cancel() {}
    }

    
    public func loadImageData(from url: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        do {
            if let imageData = try store.retrieve(dataForURL: url.url!) {
                completion(.success(imageData))
            } else {
                completion(.failure(LoadError.notFound))
            }
        } catch {
            completion(.failure(LoadError.failed))
        }
        return TaskWrapper()
    }
}
