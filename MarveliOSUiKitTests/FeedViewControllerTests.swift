//
//  MarveliOSUiKitTests.swift
//  MarveliOSUiKitTests
//
//  Created by Felipe Demetrius Martins da Silva on 10/08/24.
//

import XCTest
import UIKit
import MarvelLoader
@testable import MarveliOSUiKit

final class FeedViewControllerTests: XCTestCase {

    func test_notLoadCharactersOnOpenScreen() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.count, 0)
    }
    
    func test_viewDidLoad_LoadsFeedCountFromReload() {
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.count, 0)

        sut.simulateAppearance()
        XCTAssertEqual(loader.count, 1)

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.count, 2)
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.count, 3)
    }
    
    func test_pullRefreshBehavior() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
        
        loader.completeLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)

        loader.completeLoading(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }

    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.simulateAppearance()

        XCTAssertEqual(sut.title, localized("FEED_VIEW_TITLE"))
    }

    func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeLoadingError(at: 0)
        XCTAssertEqual(sut.errorMessage, localized("FEED_VIEW_CONNECTION_ERROR"))

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_errorView_dismissesErrorMessageOnTap() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeLoadingError(at: 0)
        XCTAssertEqual(sut.errorMessage, localized("FEED_VIEW_CONNECTION_ERROR"))

        sut.simulateTapOnErrorMessage()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeChar(description: "another description", title: "Super-man")
        let image1 = makeChar(title: "Super-man")
        let image2 = makeChar(description: "another description")
        let image3 = makeChar()
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        assertThat(sut, isRendering: [])

        loader.completeLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])

        sut.simulateUserInitiatedFeedReload()
        loader.completeLoading(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
    }

    
    //MARK: - Private helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: CharacterLoaderSpy) {
        let loader = CharacterLoaderSpy()
        let sut = FeedUIComposer.feedComposedWith(feedLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeChar(description: String = "", title: String = "", thumbnailPath: String = "http://any-url.com", thumbnailExtension: String = "jpg") -> Character {
        return Character(id: UUID().hashValue, name: title, description: description, modified: "", resourceURI: "", thumbnailPath: thumbnailPath, thumbnailExtension: thumbnailExtension)
    }

    private func anyImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
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

    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }

    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }

    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }

}
