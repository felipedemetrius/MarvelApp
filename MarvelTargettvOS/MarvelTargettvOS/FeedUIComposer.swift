//
//  FeedUIComposer.swift
//  MarvelTargettvOS
//
//  Created by Felipe Demetrius Martins da Silva on 16/09/25.
//

import UIKit
import Combine
import FeatureFeed
import MarveltvOSSwiftUI

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(
        feedLoader:  @escaping () -> CharacterLoader.Publisher,
        imageLoader:  @escaping (URLRequest) -> ImageDataLoader.Publisher
    ) -> FeedView<FeedViewModel> {
                
        let feedViewModelAdapter = FeedViewModelAdapter(loader: feedLoader)

        let viewModel = FeedViewModel(feedLoader: feedViewModelAdapter)
        
        feedViewModelAdapter.viewModel = viewModel

        viewModel.onCharacters = adaptFeedToCellControllers(
            forwardingTo: viewModel,
            imageLoader: imageLoader
        )

        let feedController = FeedView(viewModel: viewModel)
        

        return feedController
    }

    private static func adaptFeedToCellControllers(
        forwardingTo controller: FeedViewModel,
        imageLoader: @escaping (URLRequest) -> ImageDataLoader.Publisher) -> (([Character]) -> Void) {
        return { [controller, imageLoader] feed in
            controller.characters = feed.map { model in
                
                let adapter = ImageViewModelAdapter(
                    model: model,
                    loader: imageLoader)
                
                let viewModel = FeedCellState(character: model,
                                              imageLoader: adapter,
                                              imageTransformer: UIImage.init)
                
                adapter.viewModel = viewModel
                
                return viewModel
            }
        }
    }
}
