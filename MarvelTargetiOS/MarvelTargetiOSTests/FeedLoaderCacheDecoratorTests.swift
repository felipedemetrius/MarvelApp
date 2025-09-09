//
//  FeedLoaderCacheDecoratorTests.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import XCTest
import FeatureFeed
import MarvelTargetiOS

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {

    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))

        expect(sut, toCompleteWith: .success(feed))
    }

    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

    func test_load_cachesLoadedFeedOnLoaderSuccess() {
        let cache = CacheSpy()
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed), cache: cache)

        sut.load { _ in }

        XCTAssertEqual(cache.messages, [.save(feed)], "Expected to cache loaded feed on success")
    }

    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)

        sut.load { _ in }

        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache feed on load error")
    }

    // MARK: - Helpers

    private func makeSUT(loaderResult: CharacterLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> CharacterLoader {
        let loader = CharacterLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private class CacheSpy: CharacterCache {
        private(set) var messages = [Message]()

        enum Message: Equatable {
            case save([Character])
        }

        func save(_ feed: [Character]) throws {
            messages.append(.save(feed))
        }
    }

    private func uniqueFeed() -> [Character] {
        return [Character(id: UUID().hashValue, name: "name", description: "description", modified: "modified", resourceURI: "", thumbnailPath: "", thumbnailExtension: "")]
    }

}
