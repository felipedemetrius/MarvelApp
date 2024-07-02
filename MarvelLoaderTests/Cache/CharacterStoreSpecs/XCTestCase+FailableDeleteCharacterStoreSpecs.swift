//
//  XCTestCase+FailableDeleteCharacterStoreSpecs.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import XCTest
import MarvelLoader

extension FailableDeleteCharacterStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: CharacterStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: CharacterStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
