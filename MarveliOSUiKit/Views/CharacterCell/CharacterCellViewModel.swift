//
//  CharacterCellViewModel.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import Foundation
import MarvelLoader
import Combine

final class CharacterViewModel<Image> {
    private var task: ImageDataLoaderTask?
    private let model: Character
    private let imageLoader: ImageDataLoader
    private let imageTransformer: (Data) -> Image?

    init(model: Character, imageLoader: ImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    var description: String? {
        return model.description
    }

    var name: String? {
        return model.name
    }

    var onImageLoad = PassthroughSubject<Image, Never>()
    var onImageLoadingStateChange = PassthroughSubject<Bool, Never>()
    var onShouldRetryImageLoadStateChange = PassthroughSubject<Bool, Never>()

    func loadImageData() {
        guard let url = URL(string: model.urlImage) else { return }
        onImageLoadingStateChange.send(true)
        onShouldRetryImageLoadStateChange.send(false)
        task = imageLoader.loadImageData(from: url) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: ImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad.send(image)
        } else {
            onShouldRetryImageLoadStateChange.send(true)
        }
        onImageLoadingStateChange.send(false)
    }

    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
