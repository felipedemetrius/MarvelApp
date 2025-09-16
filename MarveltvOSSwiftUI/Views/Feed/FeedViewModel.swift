//
//  FeedViewModel.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 15/09/25.
//

import FeatureFeed
import SwiftUI
import UIKit
import Combine

public protocol FeedViewModelProtocol: ObservableObject {
    var characters: [FeedCellState] { get set }
    var feedLoader: CharacterLoader { get set }
    var imageLoader: ImageDataLoader { get set }
    var showRetryLoad: Bool { get set }
    var onLoading: Bool { get set }
    var errorMessage: String? { get set }
    var title: String { get set }

    func loadFeed()
}

public final class FeedViewModel: FeedViewModelProtocol {
    @Published public var characters: [FeedCellState] = []
    @Published public var showRetryLoad: Bool = false
    @Published public var onLoading: Bool = false
    @Published public var errorMessage: String?
    
    public var feedLoader: CharacterLoader
    public var imageLoader: ImageDataLoader

    public init(feedLoader: CharacterLoader, imageLoader: ImageDataLoader) {
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
        loadFeed()
    }

    public var title: String = Localized.Feed.title

    public func loadFeed() {
        let imageLoader = imageLoader
        onLoading = true
        feedLoader.load { [weak self] result in
            switch result {
            case .success(let feed):
                DispatchQueue.main.async { [weak self] in
                    self?.characters = feed.map {
                        FeedCellState(
                            character: $0,
                            imageLoader: imageLoader,
                            imageTransformer: UIImage.init
                        )
                    }
                }
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = Localized.Feed.loadError
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.onLoading = false
            }
        }
    }
}
