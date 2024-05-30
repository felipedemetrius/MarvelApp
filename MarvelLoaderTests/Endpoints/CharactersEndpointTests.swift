//
//  CharactersEndpointTests.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import XCTest
@testable import MarvelLoader

class CharactersEndpointTests: XCTestCase {
    
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = CharactersEndpoint.get(page: 0)
            .url(baseURL: baseURL)
        
        XCTAssertEqual(received.url!.scheme, "http", "scheme")
        XCTAssertEqual(received.url!.host, "base-url.com", "host")
        XCTAssertEqual(received.url!.path, "/v1/public/characters", "path")
    }
}