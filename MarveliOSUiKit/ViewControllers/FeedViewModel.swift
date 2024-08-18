//
//  FeedViewModel.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import Foundation
import MarvelLoader
import Combine

public final class FeedViewModel {
    private let feedLoader: CharacterLoader

    public init(feedLoader: CharacterLoader) {
        self.feedLoader = feedLoader
    }

    var title: String {
        Localized.Feed.title
    }

    var onLoadingStateChange = PassthroughSubject<Bool, Never>()
    var onFeedLoad = PassthroughSubject<[Character], Never>()
    var onErrorStateChange = PassthroughSubject<String?, Never>()

    func loadFeed() {
        onLoadingStateChange.send(true)
        feedLoader.load { [weak self] result in
            switch result {
            case .success(let feed):
                self?.onFeedLoad.send(feed)
            case .failure:
                self?.onErrorStateChange.send(Localized.Feed.loadError)
            }
            self?.onLoadingStateChange.send(false)
        }
    }
}
