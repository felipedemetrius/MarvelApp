//
//  HTTPClientRemoteCharactersEnd2EndTests.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import XCTest
@testable import MarvelLoader

final class HTTPClientRemoteCharactersEnd2EndTests: XCTestCase {

    func test_endToEndTestServerGETCharsResult_matchesFixedTestAccountData() {
        switch getCharactersResult(path: .characters) {
        case let .success(chars)?:
            XCTAssertEqual(chars.count, 10, "Expected 10 chars in the test account")
            XCTAssertEqual(chars[0], expectedChar(at: 0))
            XCTAssertEqual(chars[1], expectedChar(at: 1))
            XCTAssertEqual(chars[2], expectedChar(at: 2))
            XCTAssertEqual(chars[3], expectedChar(at: 3))
            XCTAssertEqual(chars[4], expectedChar(at: 4))
            XCTAssertEqual(chars[5], expectedChar(at: 5))
            XCTAssertEqual(chars[6], expectedChar(at: 6))
            XCTAssertEqual(chars[7], expectedChar(at: 7))
            XCTAssertEqual(chars[8], expectedChar(at: 8))
            XCTAssertEqual(chars[9], expectedChar(at: 9))

        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }

    func test_endToEndTestServerGETCharsResult_ErrorServer() {
        switch getCharactersResult(path: .invalidPath) {
        case .success?:
            XCTFail("Expected failure feed result, got characters instead")

        case let .failure(error)?:
            switch error {
            case .error(let error):
                XCTAssertNotNil(error)
            case .unexpectedValuesRepresentation:
                XCTFail("Expected failture with error, got no unexpectedValuesRepresentation instead")
            case .invalidData:
                XCTFail("Expected failture with error, got no invalidData instead")
            }
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }


    // MARK: - Helpers
    
    private func charsServerURL(path: Endpoints.Paths) -> URLRequest {
        return  CharactersEndpoint.get(page: 0)
            .url(path: path)
    }

    private func getCharactersResult(path: Endpoints.Paths, file: StaticString = #filePath, line: UInt = #line) -> Swift.Result<[Character], NetworkErrorCases>? {
        let client = ephemeralClient()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: Swift.Result<[Character], NetworkErrorCases>?
        client.load(from: charsServerURL(path: path)) { result in
            receivedResult = result
                .mapError({ error -> NetworkErrorCases in
                switch (error) {
                case let url_error as NetworkErrorCases:
                    return url_error
                default:
                    return NetworkErrorCases.unexpectedValuesRepresentation
                }})
                .flatMap { (data, response) in
                do {
                    return .success(try CharactersMapper.map(data, from: response))
                } catch {
                    return .failure(error as! NetworkErrorCases)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }

    private func ephemeralClient(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private func expectedChar(at index: Int) -> Character {
        return Character(
            id: id(at: index),
            name: name(at: index),
            description: description(at: index),
            modified: modified(at: index),
            resourceURI: resourceURI(at: index),
            thumbnailPath: thumbnail(at: index).path,
            thumbnailExtension: thumbnail(at: index).thumbnailExtension)
    }
    
    private func thumbnail(at index: Int) -> Thumbnail {
        return [
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/1/b0/5269678709fb7", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/9/30/535feab462a64", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/80/4c00358ec7548", thumbnailExtension: "jpg"),
            Thumbnail(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", thumbnailExtension: "jpg"),
        ][index]
    }
    
    private func id(at index: Int) -> Int {
        return [
            1011334,
            1017100,
            1009144,
            1010699,
            1009146,
            1016823,
            1009148,
            1009149,
            1010903,
            1011266,
        ][index]
    }
    
    private func name(at index: Int) -> String {
        return [
            "3-D Man",
            "A-Bomb (HAS)",
            "A.I.M.",
            "Aaron Stack",
            "Abomination (Emil Blonsky)",
            "Abomination (Ultimate)",
            "Absorbing Man",
            "Abyss",
            "Abyss (Age of Apocalypse)",
            "Adam Destine",
        ][index]
    }

    private func description(at index: Int) -> String {
        return [
            "",
            "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! ",
            "AIM is a terrorist organization bent on destroying the world.",
            "",
            "Formerly known as Emil Blonsky, a spy of Soviet Yugoslavian origin working for the KGB, the Abomination gained his powers after receiving a dose of gamma radiation similar to that which transformed Bruce Banner into the incredible Hulk.",
            "",
            "",
            "",
            "",
            "",
        ][index]
    }
    
    private func modified(at index: Int) -> String {
        return [
            "2014-04-29T14:18:17-0400",
            "2013-09-18T15:54:04-0400",
            "2013-10-17T14:41:30-0400",
            "1969-12-31T19:00:00-0500",
            "2012-03-20T12:32:12-0400",
            "2012-07-10T19:11:52-0400",
            "2013-10-24T14:32:08-0400",
            "2014-04-29T14:10:43-0400",
            "1969-12-31T19:00:00-0500",
            "1969-12-31T19:00:00-0500",
        ][index]
    }
            
    private func resourceURI(at index: Int) -> String {
        return [
            "http://gateway.marvel.com/v1/public/characters/1011334",
            "http://gateway.marvel.com/v1/public/characters/1017100",
            "http://gateway.marvel.com/v1/public/characters/1009144",
            "http://gateway.marvel.com/v1/public/characters/1010699",
            "http://gateway.marvel.com/v1/public/characters/1009146",
            "http://gateway.marvel.com/v1/public/characters/1016823",
            "http://gateway.marvel.com/v1/public/characters/1009148",
            "http://gateway.marvel.com/v1/public/characters/1009149",
            "http://gateway.marvel.com/v1/public/characters/1010903",
            "http://gateway.marvel.com/v1/public/characters/1011266",
        ][index]
    }
}
