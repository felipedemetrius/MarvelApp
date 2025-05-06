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

    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeChar()
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])

        sut.simulateUserInitiatedFeedReload()
        loader.completeLoadingError(at: 1)
        assertThat(sut, isRendering: [image0])
    }

    func test_feedImageView_loadsImageURLWhenVisible() {
        let image0 = makeChar(thumbnailPath: "http://any-url.com/photo")
        let image1 = makeChar(thumbnailPath: "http://any-url1.com/photo")
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [image0, image1], at: 0)

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [URL(string: image0.urlImage)], "Expected first image URL request once first view becomes visible")

        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [URL(string: image0.urlImage), URL(string: image1.urlImage)], "Expected second image URL request once second view also becomes visible")
    }

    func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let image0 = makeChar(thumbnailPath: "http://any-url.com/photo")
        let image1 = makeChar(thumbnailPath: "http://any-url1.com/photo")
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")

        sut.simulateFeedImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [URL(string: image0.urlImage)], "Expected one cancelled image URL request once first image is not visible anymore")

        sut.simulateFeedImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [URL(string: image0.urlImage), URL(string: image1.urlImage)], "Expected two cancelled image URL requests once second image is also not visible anymore")
    }

    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [makeChar(), makeChar()], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")

        DispatchQueue.main.async {
            loader.completeImageLoading(at: 0)
            XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
            XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")
        }

        DispatchQueue.main.async {
            loader.completeImageLoadingWithError(at: 1)
            XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
            XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
        }
    }

    func test_feedImageView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [makeChar(), makeChar()], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        
        DispatchQueue.main.async {
            XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
            XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")
        }
        

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        
        DispatchQueue.main.async {
            XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
            XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
        }
    }

    func test_feedImageViewRetryButton_isVisibleOnImageURLLoadError() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [makeChar(), makeChar()], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")

        let imageData = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")
    }
    
    func test_feedImageViewRetryButton_isVisibleOnInvalidImageData() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [makeChar()], at: 0)

        let view = sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")

        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
    }

    func test_feedImageViewRetryAction_retriesImageLoad() {
        let image0 = makeChar(thumbnailPath: "http://any-url.com/photo")
        let image1 = makeChar(thumbnailPath: "http://any-url1.com/photo")
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [image0, image1], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [URL(string: image0.urlImage), URL(string: image1.urlImage)], "Expected two image URL request for the two visible views")

        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [URL(string: image0.urlImage), URL(string: image1.urlImage)], "Expected only two image URL requests before retry action")

        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [URL(string:image0.urlImage), URL(string:image1.urlImage), URL(string:image0.urlImage)], "Expected third imageURL request after first view retry action")

        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [URL(string:image0.urlImage), URL(string: image1.urlImage), URL(string:image0.urlImage), URL(string:image1.urlImage)], "Expected fourth imageURL request after second view retry action")
    }

    func test_feedImageView_preloadsImageURLWhenNearVisible() {
        let image0 = makeChar(thumbnailPath: "http://any-url.com/photo")
        let image1 = makeChar(thumbnailPath: "http://any-url1.com/photo")
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")

        sut.simulateFeedImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [URL(string:image0.urlImage)], "Expected first image URL request once first image is near visible")

        sut.simulateFeedImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [URL(string:image0.urlImage), URL(string:image1.urlImage)], "Expected second image URL request once second image is near visible")
    }

    func test_feedImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let image0 = makeChar(thumbnailPath: "http://any-url.com/photo")
        let image1 = makeChar(thumbnailPath: "http://any-url1.com/photo")
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")

        sut.simulateFeedImageViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [URL(string:image0.urlImage)], "Expected first cancelled image URL request once first image is not near visible anymore")

        sut.simulateFeedImageViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [URL(string:image0.urlImage), URL(string:image1.urlImage)], "Expected second cancelled image URL request once second image is not near visible anymore")
    }

    func test_feedImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        loader.completeLoading(with: [makeChar()], at: 0)

        let view = sut.simulateFeedImageViewNotVisible(at: 0)
        loader.completeImageLoading(with: anyImageData())

        XCTAssertNil(view?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    }

    
    func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(with: [makeChar()], at: 0)
        _ = sut.simulateFeedImageViewVisible(at: 0)

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: self.anyImageData(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }


    //MARK: - Private helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: CharacterLoaderSpy) {
        let loader = CharacterLoaderSpy()
        let completionImageLoader: ((URL) -> ImageDataLoader) = { [loader] url in
            loader
        }
        let sut = FeedUIComposer.feedComposedWith(feedLoader: loader, imageLoader: completionImageLoader)
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
