//
//  CharacterImageDataLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import Foundation

public protocol CharacterImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
