//
//  XCTestCase+FailableInsertCharacterStoreSpecs.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import XCTest
import MarvelLoader

extension FailableInsertCharacterStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: CharacterStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: CharacterStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
