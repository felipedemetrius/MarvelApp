//
//  SceneDelegate.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import os
import UIKit
import MarveliOSUiKit
import APIFeed
import CacheFeed
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var baseURL = URLRequest(url:
        URLComponents.makeURL(path: .characters, page: nil)
    )

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var logger = Logger(subsystem: "com.marvel.study", category: "main")

    private lazy var store: CharacterStore & CharacterImageDataStore = {
        do {
            return try CoreDataCharacterStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("feed-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return InMemoryCharacterStore()
        }
    }()

    private lazy var localFeedLoader: LocalCharacterLoader = {
        LocalCharacterLoader(store: store, currentDate: Date.init)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        
        let imageDataLoader = RemoteCharacterImageDataLoader(client: httpClient)
        let remoteFeedLoader = RemoteCharacterLoader(url: baseURL, client: httpClient)
        
        let compositeFeedLoader = FeedLoaderWithFallbackComposite(
            primary: remoteFeedLoader,
            fallback: localFeedLoader
        )
        
        let localImageLoader = LocalCharacterImageDataLoader(store: store)

        let compositeImageDataLoader = CharacterImageDataLoaderWithFallbackComposite(
            primary: imageDataLoader,
            fallback: localImageLoader
        )
        
        let viewController = FeedUIComposer.feedComposedWith(
            feedLoader: compositeFeedLoader,
            imageLoader: compositeImageDataLoader
        )
            
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

