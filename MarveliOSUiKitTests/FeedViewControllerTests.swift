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
        loader?.load(completion: { _ in
            
        })
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_notLoadCharactersOnOpenScreen() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.count, 0)
    }
    
    func test_viewDidLoad_LoadsFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.count, 1)
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
    private(set) var count = 0
    
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        count += 1
    }
}
