//
//  SceneDelegate.swift
//  MarvelAppiOS
//
//  Created by Felipe Demetrius Martins da Silva on 05/05/25.
//

import os
import UIKit
import CoreData
import Combine
import MarvelLoader
import MarveliOSUiKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = {
        if let store = store as? CoreDataCharacterStore {
            return .scheduler(for: store)
        }
        
        return DispatchQueue(
            label: "com.felipesilva.infra.queue",
            qos: .userInitiated
        ).eraseToAnyScheduler()
    }()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var logger = Logger(subsystem: "com.felipesilva.MarvelApp", category: "main")
    
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
        
    private lazy var navigationController = UINavigationController(
        rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: RemoteFeedLoaderWithLocalFallback(loader: makeRemoteFeedLoaderWithLocalFallback(page: 0)),
            imageLoader: localImageLoaderWithLocalFallback))
        
    private lazy var localImageLoaderWithLocalFallback: ((URL) -> any ImageDataLoader) = {
        let loader = LocalImageLoaderWithLocalFallback(loader: makeLocalImageLoaderWithRemoteFallback)
        return { [loader] url in
            loader
        }
    }()
    
    private class LocalImageLoaderWithLocalFallback: ImageDataLoader, ImageDataLoaderTask {
        func cancel() {
            bag.forEach { $0.cancel() }
            bag.removeAll()
        }
        
        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> any MarvelLoader.ImageDataLoaderTask {
            let _ = loader(url).sink { errors in
                switch errors {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { data in
                completion(.success(data))
            }.store(in: &bag)
            
            return self
        }
        
        private let loader: (URL) -> AnyPublisher<Data, Error>
        private var bag = Set<AnyCancellable>()
        
        init(loader: @escaping (URL) -> AnyPublisher<Data, Error>) {
            self.loader = loader
        }
    }
    
    private class RemoteFeedLoaderWithLocalFallback: CharacterLoader {
        private let loader: AnyPublisher<[Character], Error>
        private var bag = Set<AnyCancellable>()
        
        init(loader: AnyPublisher<[Character], Error>) {
            self.loader = loader
        }
        
        func load(completion: @escaping (CharacterLoader.Result) -> Void) {
            loader.sink { errors in
                switch errors {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { characters in
                completion(.success(characters))
            }.store(in: &bag)
        }
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
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        scheduler.schedule { [localFeedLoader, logger] in
            do {
                try localFeedLoader.validateCache()
            } catch {
                logger.error("Failed to validate cache with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback(page: Int) -> AnyPublisher<[Character], Error> {
        makeRemoteFeedLoader(page: page)
            .receive(on: scheduler)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .mapError({ errorCases in
                errorCases
            })
            .eraseToAnyPublisher()
    }
        
    private func makeRemoteFeedLoader(page: Int = 0) -> AnyPublisher<[Character], Error> {
        let remoteCharacterLoader = RemoteCharacterLoaderImpl(httpClient: httpClient)
        
        return remoteCharacterLoader
            .get(page: page)
            .mapError({ errorCases in
                errorCases
            })
            .eraseToAnyPublisher()
    }
        
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalCharacterImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient, scheduler] in
                httpClient
                    .getPublisher(url: URLRequest(url: url))
                    .tryMap(ImageDataMapper.map)
                    .receive(on: scheduler)
                    .caching(to: localImageLoader, using: url)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
