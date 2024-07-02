//
//  InMemoryCharacterStore.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import Foundation

public class InMemoryCharacterStore {
    private var feedCache: CachedFeed?
    private var feedImageDataCache = NSCache<NSURL, NSData>()
    
    public init() {}
}

extension InMemoryCharacterStore: CharacterStore {
    public func deleteCachedFeed() throws {
        feedCache = nil
    }

    public func insert(_ feed: [LocalCharacter], timestamp: Date) throws {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
    }

    public func retrieve() throws -> CachedFeed? {
        feedCache
    }
}

extension InMemoryCharacterStore: CharacterImageDataStore {
    public func insert(_ data: Data, for url: URL) throws {
        feedImageDataCache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        feedImageDataCache.object(forKey: url as NSURL) as Data?
    }
}
