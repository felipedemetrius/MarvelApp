//
//  SceneDelegate.swift
//  MarvelTargettvOS
//
//  Created by Felipe Demetrius Martins da Silva on 16/09/25.
//

import os
import UIKit
import MarveltvOSSwiftUI
import FeatureFeed
import CacheFeed
import APIFeed
import Combine
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
    
    private lazy var remoteFeedLoader: RemoteCharacterLoader = {
        RemoteCharacterLoader(url: baseURL, client: httpClient)
    }()
    
    private lazy var remoteImageLoader = RemoteCharacterImageDataLoader(client: httpClient)

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

        let viewModel = FeedViewModel(feedLoader: remoteFeedLoader, imageLoader: remoteImageLoader)
        let view = FeedView(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: view.viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}
