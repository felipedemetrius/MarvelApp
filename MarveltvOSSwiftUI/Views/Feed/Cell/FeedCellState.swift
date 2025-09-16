//
//  FeedCellState.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 15/09/25.
//

import FeatureFeed
import SwiftUI
import UIKit
import Combine

public protocol FeedCellStateProtocol: ObservableObject {
    var character: Character { get set }
    var imageLoader: ImageDataLoader { get set }
    var image: Image? { get set }
    var showRetryImageLoad: Bool { get set }
    var onImageLoading: Bool { get set }
    
    func loadImage()
    func cancelImageDataLoad()
}

public class FeedCellState: FeedCellStateProtocol, Identifiable, Hashable {
    public let id: UUID = .init()
    @Published public var onImageLoading: Bool = false
    @Published public var showRetryImageLoad: Bool = false
    @Published public var image: Image?
    @Published public var character: Character
    public var imageLoader: any FeatureFeed.ImageDataLoader
    
    private var task: (any FeatureFeed.ImageDataLoaderTask)?
    private let imageTransformer: (Data) -> UIImage?
    
    public init(
        character: Character,
        imageLoader: any FeatureFeed.ImageDataLoader,
        imageTransformer: @escaping (Data) -> UIImage?
    ) {
        self.character = character
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    public func loadImage() {
        guard image == nil else { return }
        guard let urlImage = URL(string: character.urlImage) else { return }
        let url = URLRequest(url: urlImage)
        DispatchQueue.main.async { [weak self] in
            self?.onImageLoading = true
            self?.showRetryImageLoad = false
        }
        task = imageLoader.loadImageData(from: url) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.handle(result)
            }
        }
    }
    
    private func handle(_ result: ImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            DispatchQueue.main.async { [weak self] in
                self?.image = Image(uiImage: image)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showRetryImageLoad = true
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.onImageLoading = false
        }
    }

    public func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
    
    public static func == (lhs: FeedCellState, rhs: FeedCellState) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
