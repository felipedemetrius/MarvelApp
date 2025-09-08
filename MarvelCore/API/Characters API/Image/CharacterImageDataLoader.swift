//
//  CharacterImageDataLoader.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import Foundation

public protocol CharacterImageDataLoaderTask {
    func cancel()
}

public protocol CharacterImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URLRequest, completion: @escaping (Result) -> Void) -> CharacterImageDataLoaderTask
}
