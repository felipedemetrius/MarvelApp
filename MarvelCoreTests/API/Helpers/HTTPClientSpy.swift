//
//  HTTPClientSpy.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import APIFeed
import Foundation
import XCTest

class HTTPClientSpy: HTTPClient {
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: () -> Void
        
        func cancel() {
            wrapped()
        }
    }

    private(set) var cancelledURLs = [URLRequest]()
    private var messages = [(url: URLRequest, completion: (HTTPClient.Result) -> Void)]()

    var requestedURLs: [URLRequest] {
        return messages.map { $0.url }
    }

    func load(from url: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> any APIFeed.HTTPClientTask {
        messages.append((url, completion))
        return URLSessionTaskWrapper { [weak self] in self?.cancelledURLs.append(url) }
    }

    func complete(with error: Error, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard messages.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: line)
        }

        messages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard requestedURLs.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: line)
        }

        let response = HTTPURLResponse(
            url: requestedURLs[index].url!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!

        messages[index].completion(.success((data, response)))
    }
}
