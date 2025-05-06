//
//  FeedUIComposer.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
import MarvelLoader
import Combine

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(
        feedLoader: CharacterLoader,
        imageLoader: @escaping (URL) -> any ImageDataLoader) -> FeedViewController {
        
        let feedViewModel = FeedViewModel(
            feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))

        let feedController = FeedViewController(viewModel: feedViewModel)
                
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, imageLoader: imageLoader)
        
        return feedController
    }

    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, imageLoader: @escaping (URL) -> any ImageDataLoader) -> (([Character]) -> Void) {
        return { [weak controller, imageLoader] feed in
            controller?.tableModel = feed.map { model in
                CharacterCellController(viewModel:
                                            CharacterViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
                
            }
        }
    }
}
