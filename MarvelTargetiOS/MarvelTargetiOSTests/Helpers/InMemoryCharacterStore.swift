//
//  InMemoryCharacterStore.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 13/09/25.
//

import Foundation
import CacheFeed

class InMemoryCharacterStore {
    private(set) var feedCache: CachedFeed?
    private var feedImageDataCache: [URL: Data] = [:]
    
    private init(feedCache: CachedFeed? = nil) {
        self.feedCache = feedCache
    }
}

extension InMemoryCharacterStore: CharacterStore {
    func deleteCachedFeed() throws {
        feedCache = nil
    }
    
    func insert(_ feed: [LocalCharacter], timestamp: Date) throws {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
    }
    
    func retrieve() throws -> CachedFeed? {
        feedCache
    }
}

extension InMemoryCharacterStore: CharacterImageDataStore {
    func insert(_ data: Data, for url: URL) throws {
        feedImageDataCache[url] = data
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        feedImageDataCache[url]
    }
}

extension InMemoryCharacterStore {
    static var empty: InMemoryCharacterStore {
        InMemoryCharacterStore()
    }
    
    static var withExpiredFeedCache: InMemoryCharacterStore {
        InMemoryCharacterStore(feedCache: CachedFeed(feed: [], timestamp: Date.distantPast))
    }
    
    static var withNonExpiredFeedCache: InMemoryCharacterStore {
        InMemoryCharacterStore(feedCache: CachedFeed(feed: [], timestamp: Date()))
    }
}
