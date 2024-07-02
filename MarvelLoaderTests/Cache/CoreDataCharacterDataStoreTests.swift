//
//  CoreDataCharacterImageDataStoreTests.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 02/07/24.
//

import XCTest
import MarvelLoader

class CoreDataCharacterImageDataStoreTests: XCTestCase, CharacterImageDataStoreSpecs {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
        }
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataCharacterStore, URL) -> Void, file: StaticString = #filePath, line: UInt = #line) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataCharacterStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        let exp = expectation(description: "wait for operation")
        sut.perform {
            let imageDataURL = URL(string: "http://a-url.com/image.jpg")!
            insertCharacter(with: imageDataURL, into: sut, file: file, line: line)
            test(sut, imageDataURL)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
}

private func insertCharacter(with url: URL, into sut: CoreDataCharacterStore, file: StaticString = #filePath, line: UInt = #line) {
    do {
        let image = LocalCharacter(id: 11, name: "name", description: "description", modified: "", resourceURI: "", thumbnail: LocalThumbnail(path: "http://a-url.com/image", thumbnailExtension: "jpg"))
        try sut.insert([image], timestamp: Date())
    } catch {
        XCTFail("Failed to insert feed image with URL \(url) - error: \(error)", file: file, line: line)
    }
}
