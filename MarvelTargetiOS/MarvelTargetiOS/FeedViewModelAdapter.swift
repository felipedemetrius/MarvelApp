//
//  FeedViewModelAdapter.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 13/09/25.
//

import Combine
import FeatureFeed
import MarveliOSUiKit

final class FeedViewModelAdapter: CharacterLoader {
    private let loader: () -> CharacterLoader.Publisher
    private var cancellable: Cancellable?
    private var isLoading = false
    
    weak var viewModel: FeedViewModel?
    
    init(loader: @escaping () -> CharacterLoader.Publisher) {
        self.loader = loader
    }
    
    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        guard !isLoading else { return }
        
        viewModel?.onLoadingStateChange.send(true)
        isLoading = true
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] result in
                    self?.viewModel?.onLoadingStateChange.send(false)
                    switch result {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.viewModel?.onErrorStateChange.send(Localized.Feed.loadError)
                    }
                    
                    self?.isLoading = false
                }, receiveValue: { [weak self] resource in
                    self?.viewModel?.onLoadingStateChange.send(false)
                    self?.viewModel?.onFeedLoad?(resource)
                })
    }
}
