//
//  RemoteCharacterImageDataLoader.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import Foundation
import FeatureFeed

public final class RemoteCharacterImageDataLoader: ImageDataLoader {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    private final class HTTPClientTaskWrapper: ImageDataLoaderTask {
        private var completion: ((ImageDataLoader.Result) -> Void)?

        var wrapped: HTTPClientTask?

        init(_ completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: ImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.load(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in NetworkErrorCases.unexpectedValuesRepresentation }
                .flatMap { (data, response) in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(NetworkErrorCases.invalidData)
                })
        }
        return task
    }
}
