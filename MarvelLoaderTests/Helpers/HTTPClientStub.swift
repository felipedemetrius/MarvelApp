//
//  HTTPClientStub.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation
import MarvelLoader

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URLRequest) -> HTTPClient.Result
    
    init(stub: @escaping (URLRequest) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func get(from url: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    static func online(_ stub: @escaping (URLRequest) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
