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
        
        //record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "NOT_EMPTY_FEED_light")
        //record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "NOT_EMPTY_FEED_dark")

        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "NOT_EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "NOT_EMPTY_FEED_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> FeedViewController {
        let controller = FeedViewController(viewModel: FeedViewModel(feedLoader: AlwaysSucceedingFeedLoader()))
        controller.simulateAppearance()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyFeed() -> [CharacterCellController] {
        []
    }
    
    private func notEmptyFeed() -> [CharacterCellController] {
        let spy = CharacterLoaderSpy()
        let loader = ImageLoader(loader: spy) { url in
            spy
        }
        let array = [CharacterCellController(viewModel: CharacterViewModel(model: Character(id: 0, name: "Super-man", description: "a description", modified: "", resourceURI: "", thumbnailPath: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", thumbnailExtension: "jpg"), imageLoader: loader.completionImage, imageTransformer: UIImage.init)),
                     CharacterCellController(viewModel: CharacterViewModel(model: Character(id: 1, name: "Spider-man", description: "another description hehehehe", modified: "", resourceURI: "", thumbnailPath: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16", thumbnailExtension: "jpg"), imageLoader: loader.completionImage, imageTransformer: UIImage.init))]
        return array
    }
    
    private class ImageLoader: ImageDataLoader, ImageDataLoaderTask {
        func cancel() {
            cancellable?.cancel()
        }
        
        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> any MarvelLoader.ImageDataLoaderTask {
            let cancellable = loader.loadImageData(from: url, completion: completion)
            self.cancellable = cancellable
            return cancellable
        }
        
        private let loader: ImageDataLoader
        private var cancellable: (any ImageDataLoaderTask)?
        public var completionImage: ((URL) -> ImageDataLoader)
        
        init(loader: ImageDataLoader, completionImage: @escaping ((URL) -> ImageDataLoader)) {
            self.loader = loader
            self.completionImage = completionImage
        }
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
