//
//  CharacterStore.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import Foundation

public typealias CachedFeed = (feed: [LocalCharacter], timestamp: Date)

public protocol CharacterStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalCharacter], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
