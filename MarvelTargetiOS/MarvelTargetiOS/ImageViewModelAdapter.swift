//
//  ImageViewModelAdapter.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 13/09/25.
//

import Combine
import FeatureFeed
import MarveliOSUiKit
import Foundation
import UIKit

final class ImageViewModelAdapter: ImageDataLoader {
    private let loader: (URLRequest) -> ImageDataLoader.Publisher
    private var cancellable: Cancellable?
    private var isLoading = false
    private let model: Character
    
    weak var viewModel: CharacterViewModel<UIImage>?
    
    init(model: Character, loader: @escaping (URLRequest) -> ImageDataLoader.Publisher) {
        self.loader = loader
        self.model = model
    }
    
    struct ImageDataLoaderTaskWrapper: ImageDataLoaderTask {
        let cancellable: Cancellable
        
        func cancel() {
            cancellable.cancel()
        }
    }
    
    func loadImageData(from url: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> any FeatureFeed.ImageDataLoaderTask {
        
        viewModel?.onImageLoadingStateChange.send(true)
        isLoading = true
        
        let url = URLRequest(url: URL(string: model.urlImage)!)
        
        let cancellable = loader(url)
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished: break
                        
                    case .failure:
                        self?.viewModel?.onShouldRetryImageLoadStateChange.send(true)
                    }
                    self?.viewModel?.onImageLoadingStateChange.send(false)

                    self?.isLoading = false
                }, receiveValue: { [weak self] resource in
                    guard let image = UIImage(data: resource) else {
                        self?.viewModel?.onImageLoadingStateChange.send(false)
                        self?.viewModel?.onShouldRetryImageLoadStateChange.send(true)
                        return
                    }
                    self?.viewModel?.onImageLoad.send(image)
                })
        
        self.cancellable = cancellable
        
        let cancellableWrapper = ImageDataLoaderTaskWrapper(cancellable: cancellable)
        return cancellableWrapper
    }
}
