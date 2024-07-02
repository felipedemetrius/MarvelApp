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
        let received = CharactersEndpoint.get(page: 0)
            .url(path: .characters)
        
        XCTAssertEqual(received.url!.scheme, Endpoints.baseURL.scheme, "scheme")
        XCTAssertEqual(received.url!.host, Endpoints.baseURL.host, "host")
        XCTAssertEqual(received.url!.path, Endpoints.Paths.characters.rawValue, "path")
    }
}
