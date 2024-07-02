//
//  XCTestCase+FailableRetrieveCharacterStoreSpecs.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import XCTest
import MarvelLoader

extension FailableRetrieveCharacterStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: CharacterStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: CharacterStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
