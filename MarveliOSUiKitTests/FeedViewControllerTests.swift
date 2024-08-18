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
        let loader = CharacterLoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.count, 0)
    }
    
    func test_viewDidLoad_LoadsFeed() {
        let loader = CharacterLoaderSpy()
        let view = FeedViewController(loader: loader)
        
        view.loadViewIfNeeded()
        
        XCTAssertEqual(loader.count, 1)
    }
}

final class CharacterLoaderSpy: CharacterLoader {
    private(set) var count = 0
    
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        count += 1
    }
}
