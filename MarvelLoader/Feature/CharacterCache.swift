//
//  CharacterCache.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 26/06/24.
//

import Foundation

public protocol CharacterCache {
    func save(_ feed: [Character]) throws
}
