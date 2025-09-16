//
//  ImageViewModelAdapter.swift
//  MarvelTargettvOS
//
//  Created by Felipe Demetrius Martins da Silva on 16/09/25.
//
import Combine
import FeatureFeed
import MarveltvOSSwiftUI
import Foundation
import UIKit
import SwiftUI

final class ImageViewModelAdapter: ImageDataLoader {
    private let loader: (URLRequest) -> ImageDataLoader.Publisher
    private var cancellable: Cancellable?
    private var isLoading = false
    private let model: Character
    
    weak var viewModel: FeedCellState?
    
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
        
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.onImageLoading = true
        }
        
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
                        self?.viewModel?.showRetryImageLoad = true
                    }
                    self?.viewModel?.onImageLoading = false

                    self?.isLoading = false
                }, receiveValue: { [weak self] resource in
                    guard let imageData = UIImage(data: resource) else {
                        self?.viewModel?.onImageLoading = false
                        self?.viewModel?.showRetryImageLoad = true
                        return
                    }
                    self?.viewModel?.image = Image(uiImage: imageData)
                })
        
        self.cancellable = cancellable
        
        let cancellableWrapper = ImageDataLoaderTaskWrapper(cancellable: cancellable)
        return cancellableWrapper
    }
}

