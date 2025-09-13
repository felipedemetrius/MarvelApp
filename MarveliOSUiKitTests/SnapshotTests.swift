//
//  SnapshotTests.swift
//  MarveliOSUiKitTests
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import XCTest
import FeatureFeed
@testable import MarveliOSUiKit

class FeedUISnapshotTests: XCTestCase {
    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "EMPTY_FEED_dark")
        
//        record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "EMPTY_FEED_light")
//        record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "EMPTY_FEED_dark")

    }

    func test_feedWithError() {
        let sut = makeSUT()

        sut.display(errorMessage: "An error message")

        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "FEED_WITH_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "FEED_WITH_ERROR_dark")
        
//        record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "FEED_WITH_ERROR_light")
//        record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "FEED_WITH_ERROR_dark")

    }

    func test_notEmptyFeed() {
        let sut = makeSUT()

        sut.display(notEmptyFeed())
        
//        record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "NOT_EMPTY_FEED_light")
//        record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "NOT_EMPTY_FEED_dark")

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

final class CharacterLoaderSpy: CharacterLoader, ImageDataLoader {
    var count: Int {
        completions.count
    }
    
    private(set) var completions: [(CharacterLoader.Result) -> Void] = []
    
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        completions.append(completion)
    }
    
    func completeLoading(with feed: [Character] = [], at index: Int) {
        completions[index](.success(feed))
    }
    
    func completeLoadingError(at index: Int) {
        completions[index](.failure(NSError(domain: "", code: 0)))
    }
    
    // MARK: - FeedImageDataLoader

    private struct TaskSpy: ImageDataLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }

    private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()

    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }

    private(set) var cancelledImageURLs = [URL]()

    func loadImageData(from url: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> any FeatureFeed.ImageDataLoaderTask {
        imageRequests.append((url.url!, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url.url!) }
    }

    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }

    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }

}

extension FeedViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            prepareForFirstAppearance()
        }
        
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    private func prepareForFirstAppearance() {
        replaceRefreshControlWithSpyForiOS17Support()
    }

    private func replaceRefreshControlWithSpyForiOS17Support() {
        let spyRefreshControl = UIRefreshControlSpy()

        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                spyRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }

        refreshControl = spyRefreshControl
    }

    private class UIRefreshControlSpy: UIRefreshControl {
        private var _isRefreshing = false

        override var isRefreshing: Bool { _isRefreshing }

        override func beginRefreshing() {
            _isRefreshing = true
        }

        override func endRefreshing() {
            _isRefreshing = false
        }
    }
}
