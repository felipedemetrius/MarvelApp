//
//  ImageDataLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import Foundation

public protocol ImageDataLoaderTask {
    func cancel()
}

public protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}
