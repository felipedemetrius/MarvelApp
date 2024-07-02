//
//  CharacterImageDataStoreSpy.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 01/07/24.
//

import Foundation
import MarvelLoader

class CharacterImageDataStoreSpy: CharacterImageDataStore {
    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }
    
    private(set) var receivedMessages = [Message]()
    private var retrievalResult: Result<Data?, Error>?
    private var insertionResult: Result<Void, Error>?
    
    func insert(_ data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        receivedMessages.append(.retrieve(dataFor: url))
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with data: Data?) {
        retrievalResult = .success(data)
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
}
