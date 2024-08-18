//
//  SnapshotTests.swift
//  MarveliOSUiKitTests
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import XCTest
import MarvelLoader
@testable import MarveliOSUiKit

class FeedUISnapshotTests: XCTestCase {
    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "EMPTY_FEED_dark")
    }

    func test_feedWithError() {
        let sut = makeSUT()

        sut.display(errorMessage: "An error message")

        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "FEED_WITH_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "FEED_WITH_ERROR_dark")
    }

    func test_notEmptyFeed() {
        let sut = makeSUT()

        sut.display(notEmptyFeed())
        
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "NOT_EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "NOT_EMPTY_FEED_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> FeedViewController {
        let loader = AlwaysSucceedingFeedLoader()
        let controller = FeedViewController(viewModel: FeedViewModel(feedLoader: loader))
        controller.simulateAppearance()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyFeed() -> [CharacterCellController] {
        []
    }
    
    private func notEmptyFeed() -> [CharacterCellController] {
        [CharacterCellController(viewModel: CharacterViewModel(model: Character(id: 0, name: "Super-man", description: "a description", modified: "", resourceURI: "", thumbnailPath: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", thumbnailExtension: "jpg"), imageLoader: CharacterLoaderSpy(), imageTransformer: UIImage.init)),
         CharacterCellController(viewModel: CharacterViewModel(model: Character(id: 1, name: "Spider-man", description: "another description hehehehe", modified: "", resourceURI: "", thumbnailPath: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16", thumbnailExtension: "jpg"), imageLoader: CharacterLoaderSpy(), imageTransformer: UIImage.init))]
    }
}

private class AlwaysSucceedingFeedLoader: CharacterLoader {
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        completion(.success([]))
    }
}

private extension FeedViewController {
    func display(errorMessage: String) {
        errorView.message = errorMessage
    }

    func display(_ feed: [CharacterCellController]) {
        tableModel = feed
    }
}
