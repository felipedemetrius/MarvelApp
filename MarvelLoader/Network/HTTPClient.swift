//
//  HTTPClient.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func load(from url: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
