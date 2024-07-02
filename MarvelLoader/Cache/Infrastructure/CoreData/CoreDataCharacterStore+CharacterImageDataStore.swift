//
//  CoreDataCharacterStore+CharacterImageDataStore.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 02/07/24.
//

extension CoreDataCharacterStore: CharacterImageDataStore {
    
    public func insert(_ data: Data, for url: URL) throws {
        try ManagedCharacter.first(with: url, in: context)
            .map { $0.data = data }
            .map(context.save)
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try ManagedCharacter.data(with: url, in: context)
    }
    
}
