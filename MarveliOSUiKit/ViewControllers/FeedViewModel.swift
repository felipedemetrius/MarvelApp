//
//  FeedViewModel.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import Foundation
import Combine
import FeatureFeed

public final class FeedViewModel {
    private let feedLoader: CharacterLoader

    public init(feedLoader: CharacterLoader) {
        self.feedLoader = feedLoader
    }

    public var title: String = Localized.Feed.title

    public var onLoadingStateChange = PassthroughSubject<Bool, Never>()
    public var onFeedLoad: (([Character]) -> Void)?
    public var onErrorStateChange = PassthroughSubject<String?, Never>()

    public func loadFeed() {
        onLoadingStateChange.send(true)
        feedLoader.load { [weak self] result in
            switch result {
            case .success(let feed):
                self?.onFeedLoad?(feed)
            case .failure:
                self?.onErrorStateChange.send(Localized.Feed.loadError)
            }
            self?.onLoadingStateChange.send(false)
        }
    }
}
