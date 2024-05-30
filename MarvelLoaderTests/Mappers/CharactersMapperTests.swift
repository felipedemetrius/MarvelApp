//
//  CharactersMapperTests.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import XCTest
import MarvelLoader

class CharactersMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try CharactersMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try CharactersMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try CharactersMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: 123, name: "name", description: "desc", modified: "ontem", resourceURI: "http://another-url.com", thumbnail: Thumbnail(path: "http://another-url.com", thumbnailExtension: "jpg"))
        
        let item2 = makeItem(id: 321, name: "algum", description: "muito tri", modified: "hoje", resourceURI: "http://another-url.com", thumbnail: Thumbnail(path: "http://some-url.com", thumbnailExtension: "jpg"))
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try CharactersMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    private func makeItem(id: Int, name: String, description: String, modified: String, resourceURI: String, thumbnail: Thumbnail) -> (model: Character, json: [String: Any]) {
        
        let item = Character(id: id, name: name, description: description, modified: modified, resourceURI: resourceURI, thumbnailPath: thumbnail.path, thumbnailExtension: thumbnail.thumbnailExtension)
        
        let json2 = [
            "path": thumbnail.path,
            "extension": thumbnail.thumbnailExtension
        ]
        
        let json = [
            "id": id,
            "name": name,
            "description": description,
            "modified": modified,
            "resourceURI": resourceURI,
            "thumbnail": json2
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
}
