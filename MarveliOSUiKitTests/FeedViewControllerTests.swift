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

    //MARK: - Private helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: CharacterLoaderSpy) {
        let loader = CharacterLoaderSpy()
        let viewModel = FeedViewModel(feedLoader: loader)
        let sut = FeedViewController(viewModel: viewModel)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(viewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}

final class CharacterLoaderSpy: CharacterLoader {
    var count: Int {
        completions.count
    }
    
    private(set) var completions: [(CharacterLoader.Result) -> Void] = []
    
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        completions.append(completion)
    }
    
    func completeLoading(at index: Int) {
        completions[index](.success([]))
    }
}
