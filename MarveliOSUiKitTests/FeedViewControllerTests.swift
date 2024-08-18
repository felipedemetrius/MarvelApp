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

final class FeedViewController: UITableViewController {
    private var onViewIsAppearing: (() -> Void)?

    var loader: CharacterLoader?
    
    init (loader: CharacterLoader) {
        self.loader = loader
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        onViewIsAppearing = { [weak self] in
            self?.load()
            self?.onViewIsAppearing = nil
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewIsAppearing?()
    }

    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_notLoadCharactersOnOpenScreen() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.count, 0)
    }
    
    func test_viewDidLoad_LoadsFeed() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        
        XCTAssertEqual(loader.count, 1)
    }
    
    func test_loadsPullToRefresh() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        XCTAssertEqual(loader.count, 1)

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.count, 2)
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.count, 3)
    }
    
    func test_showsUIRefreshControl() {
        let (sut, _) = makeSUT()

        sut.simulateAppearance()
        sut.refreshControl?.simulatePullToRefresh()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }

    func test_hideUIRefreshControl() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        loader.completeLoading(at: 0)
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }

    func test_pullToRefresh_showsLoading() {
        let (sut, loader) = makeSUT()

        sut.simulateAppearance()
        sut.simulateUserInitiatedFeedReload()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }

    //MARK: - Private helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: CharacterLoaderSpy) {
        let loader = CharacterLoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
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
