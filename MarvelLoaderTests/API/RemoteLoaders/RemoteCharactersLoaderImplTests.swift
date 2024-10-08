//
//  RemoteCharactersLoaderImplTests.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import XCTest
import Combine
import MarvelLoader

class RemoteCharactersLoaderImplTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    func test_remoteCharactersLoaderGetMock() {
        let httpClient: HTTPClientStub = .online(response)
        let sut = RemoteCharacterLoaderImpl(httpClient: httpClient)
        let exp = expectation(description: "Wait for request")

        sut.get().sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                XCTFail("Expected successful feed result, got \(error) instead")
            }
            exp.fulfill()
        } receiveValue: { chars in
            XCTAssertEqual(chars.count, 2)
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
        
        trackForMemoryLeaks(sut)
    }
    
    func test_remoteCharactersLoaderGetMockOffline() {
        let httpClient: HTTPClientStub = .offline
        let sut = RemoteCharacterLoaderImpl(httpClient: httpClient)
        let exp = expectation(description: "Wait for request")

        sut.get().sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        } receiveValue: { chars in
            XCTFail("Expected failure")
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
        
        trackForMemoryLeaks(sut)
    }

    
    //MARK: - Helpers
    
    private func response(for url: URLRequest) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url.url!), response)
    }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/v1/public/characters":
            return makeFirstCharsPageData()
            
        default:
            return Data()
        }
    }

    private func makeFirstCharsPageData() -> Data {
        let jsonString = jsonStringResponseCharacters
        
        return Data(jsonString)        
    }
}
