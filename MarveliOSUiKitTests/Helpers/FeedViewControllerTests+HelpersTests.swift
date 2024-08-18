//
//  FeedViewControllerTests+HelpersTests.swift
//  MarveliOSUiKitTests
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import XCTest
import MarvelLoader
import MarveliOSUiKit

extension FeedViewControllerTests {
    func assertThat(_ sut: FeedViewController, isRendering feed: [Character], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
        }

        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: FeedViewController, hasViewConfiguredFor image: Character, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.feedImageView(at: index)

        guard let cell = view as? CharacterCell else {
            return XCTFail("Expected \(CharacterCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.nameText, image.name, "Expected name text to be \(String(describing: image.name)) for image  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(String(describing: image.description)) for image view at index (\(index)", file: file, line: line)
    }
}
