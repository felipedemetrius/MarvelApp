//
//  FeedUIComposer.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
import Combine
import FeatureFeed
import MarveliOSUiKit

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(
        feedLoader:  @escaping () -> CharacterLoader.Publisher,
        imageLoader:  @escaping (URLRequest) -> ImageDataLoader.Publisher
    ) -> FeedViewController {
        
        let feedViewModelAdapter = FeedViewModelAdapter(loader: feedLoader)

        let viewModel = FeedViewModel(feedLoader: feedViewModelAdapter)
        
        feedViewModelAdapter.viewModel = viewModel

        let feedController = FeedViewController(viewModel: viewModel)
        
        viewModel.onFeedLoad = adaptFeedToCellControllers(
            forwardingTo: feedController,
            imageLoader: imageLoader
        )

        return feedController
    }

    private static func adaptFeedToCellControllers(
        forwardingTo controller: FeedViewController,
        imageLoader: @escaping (URLRequest) -> ImageDataLoader.Publisher) -> (([Character]) -> Void) {
        return { [weak controller, imageLoader] feed in
            controller?.setTableModel(feed.map { model in
                let adapter = ImageViewModelAdapter(
                    model: model,
                    loader: imageLoader)
                
                let viewModel = CharacterViewModel(model: model,
                                                   imageLoader: adapter,
                                                   imageTransformer: UIImage.init)
                
                adapter.viewModel = viewModel
                
                
                return CharacterCellController(viewModel: viewModel)
            })
        }
    }
}
