//
//  CharacterDataImageCache.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import Foundation

public protocol CharacterDataImageCache {
    func save(_ data: Data, for url: URL) throws
}
