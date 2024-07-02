//
//  CharacterStoreSpecs.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import Foundation

protocol CharacterStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() throws
    func test_retrieve_hasNoSideEffectsOnEmptyCache() throws
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws
    
    func test_insert_deliversNoErrorOnEmptyCache() throws
    func test_insert_deliversNoErrorOnNonEmptyCache() throws
    func test_insert_overridesPreviouslyInsertedCacheValues() throws
    
    func test_delete_deliversNoErrorOnEmptyCache() throws
    func test_delete_hasNoSideEffectsOnEmptyCache() throws
    func test_delete_deliversNoErrorOnNonEmptyCache() throws
    func test_delete_emptiesPreviouslyInsertedCache() throws
}

protocol FailableRetrieveCharacterStoreSpecs: CharacterStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError() throws
    func test_retrieve_hasNoSideEffectsOnFailure() throws
}

protocol FailableInsertCharacterStoreSpecs: CharacterStoreSpecs {
    func test_insert_deliversErrorOnInsertionError() throws
    func test_insert_hasNoSideEffectsOnInsertionError() throws
}

protocol FailableDeleteCharacterStoreSpecs: CharacterStoreSpecs {
    func test_delete_deliversErrorOnDeletionError() throws
    func test_delete_hasNoSideEffectsOnDeletionError() throws
}

typealias FailableFeedStoreSpecs = FailableRetrieveCharacterStoreSpecs & FailableInsertCharacterStoreSpecs & FailableDeleteCharacterStoreSpecs
