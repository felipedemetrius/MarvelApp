//
//  ImageDataMapper.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 06/05/25.
//

import Foundation

public final class ImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
