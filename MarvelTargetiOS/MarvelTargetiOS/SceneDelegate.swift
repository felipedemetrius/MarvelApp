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
import FeatureFeed

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
    
    private lazy var remoteFeedLoader: RemoteCharacterLoader = {
        RemoteCharacterLoader(url: baseURL, client: httpClient)
    }()

    func sceneWillResignActive(_ scene: UIScene) {
        try? localFeedLoader.validateCache()
    }
    
    convenience init(httpClient: HTTPClient, store: CharacterStore & CharacterImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        
        let viewController = FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback
        )
        
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func makeRemoteFeedLoaderWithLocalFallback() -> CharacterLoader.Publisher {
        return remoteFeedLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }

    private func makeLocalImageLoaderWithRemoteFallback(url: URLRequest) -> ImageDataLoader.Publisher {
        let remoteImageLoader = RemoteCharacterImageDataLoader(client: httpClient)
        let localImageLoader = LocalCharacterImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url.url!)
            })
    }
}

