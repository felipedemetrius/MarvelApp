//
//  HTTPClient+URLSessions.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func load(from url: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        Logger.shared.log(url: url)
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    Logger.shared.log(error: error)
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    Logger.shared.log(data: data, response: response)
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
