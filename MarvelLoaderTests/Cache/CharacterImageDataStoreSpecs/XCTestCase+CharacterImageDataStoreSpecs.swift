//
//  XCTestCase+CharacterImageDataStoreSpecs.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import XCTest
import Foundation
import MarvelLoader

extension CharacterImageDataStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(
        on sut: CharacterImageDataStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toCompleteRetrievalWith: notFound(), for: imageDataURL, file: file, line: line)
    }
    
    func assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(
        on sut: CharacterImageDataStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let nonMatchingURL = URL(string: "http://a-non-matching-url.com")!
        
        insert(anyData(), for: imageDataURL, into: sut, file: file, line: line)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL, file: file, line: line)
    }
    
    func assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(
        on sut: CharacterImageDataStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let storedData = anyData()
        
        insert(storedData, for: imageDataURL, into: sut, file: file, line: line)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), for: imageDataURL, file: file, line: line)
    }
    
    func assertThatRetrieveImageDataDeliversLastInsertedValueForURL(
        on sut: CharacterImageDataStore,
        imageDataURL: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        
        insert(firstStoredData, for: imageDataURL, into: sut, file: file, line: line)
        insert(lastStoredData, for: imageDataURL, into: sut, file: file, line: line)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: imageDataURL, file: file, line: line)
    }
    
}

extension CharacterImageDataStoreSpecs where Self: XCTestCase {
    
    func notFound() -> Result<Data?, Error> {
        .success(.none)
    }
    
    func found(_ data: Data) -> Result<Data?, Error> {
        .success(data)
    }
    
    func expect(_ sut: CharacterImageDataStore, toCompleteRetrievalWith expectedResult: Result<Data?, Error>, for url: URL,  file: StaticString = #filePath, line: UInt = #line) {
        let receivedResult = Result { try sut.retrieve(dataForURL: url) }
        
        switch (receivedResult, expectedResult) {
        case let (.success( receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
    
    func insert(_ data: Data, for url: URL, into sut: CharacterImageDataStore, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try sut.insert(data, for: url)
        } catch {
            XCTFail("Failed to insert image data: \(data) - error: \(error)", file: file, line: line)
        }
    }
    
}
