//
//  MainQueueDispatchDecorator.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import Foundation
import MarvelLoader

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension MainQueueDispatchDecorator: CharacterLoader where T == CharacterLoader {
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: ImageDataLoader where T == (URL) -> ImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        return decoratee(url).loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
