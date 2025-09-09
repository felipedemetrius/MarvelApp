//
//  CharacterLoaderStub.swift
//  MarvelTargetiOS
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import FeatureFeed

class CharacterLoaderStub: CharacterLoader {
    private let result: CharacterLoader.Result

    init(result: CharacterLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (CharacterLoader.Result) -> Void) {
        completion(result)
    }
}
