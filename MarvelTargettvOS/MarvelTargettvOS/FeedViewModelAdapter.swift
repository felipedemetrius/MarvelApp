//
//  FeedViewModelAdapter.swift
//  MarvelTargettvOS
//
//  Created by Felipe Demetrius Martins da Silva on 16/09/25.
//

import Combine
import FeatureFeed
import MarveltvOSSwiftUI
import UIKit

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
        viewModel?.onLoading = true
        isLoading = true
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] result in
                    self?.viewModel?.onLoading = false
                    switch result {
                    case .finished: break
                        
                    case .failure:
                        self?.viewModel?.errorMessage = Localized.Feed.loadError
                    }
                    
                    self?.isLoading = false
                }, receiveValue: { [weak self] resource in
                    self?.viewModel?.onLoading = false
                    self?.viewModel?.onCharacters?(resource)
                })
    }
}
