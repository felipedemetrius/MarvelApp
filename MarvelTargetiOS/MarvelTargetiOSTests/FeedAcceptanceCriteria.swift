//
//  FeedAcceptanceCriteria.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 13/09/25.
//

import XCTest
import FeatureFeed
import CacheFeed
import MarveliOSUiKit
@testable import MarvelTargetiOS

class FeedAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryCharacterStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)

        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 2)
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryCharacterStore.withExpiredFeedCache
        
        enterBackground(with: store)

        XCTAssertNil(store.feedCache, "Expected to delete expired cache")
    }
    
    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryCharacterStore.withNonExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNotNil(store.feedCache, "Expected to keep non-expired cache")
    }
    
    // MARK: - Helpers

    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryCharacterStore = .empty
    ) -> FeedViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 1))
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let vc = nav?.topViewController as! FeedViewController
        vc.simulateAppearance()
        return vc
    }
    
    private func enterBackground(with store: InMemoryCharacterStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }

    private func response(for url: URLRequest) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url.url!), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()
            
        default:
            return makeFeedData()
        }
    }
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func makeFeedData() -> Data {
        let thumb: [String: Any] = ["path":"http://image.com", "extension": ""]
        let items: [[String: Any]] = [
            ["id":1011334, "name":"3-D Man", "thumbnail": thumb],
            ["id":1011335, "name":"4-D Man", "thumbnail": thumb],
        ]
        let json2 = ["results": items]
        let json = ["data": json2]
        return try! JSONSerialization.data(withJSONObject: json)
    }

}
