//
//  CharacterResponse.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 30/05/24.
//

import Foundation

struct CharacterResponse: Decodable {
    let id: Int?
    let name, description, modified: String?
    let resourceURI: String?
    let thumbnail: ThumbnailResponse?
}
