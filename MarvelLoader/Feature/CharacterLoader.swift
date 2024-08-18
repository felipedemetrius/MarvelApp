//
//  CharacterLoader.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import Foundation

public protocol CharacterLoader {
    typealias Result = Swift.Result<[Character], Error>

    func load(completion: @escaping (Result) -> Void)
}
