//
//  RemoteCharacterLoader.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 08/09/25.
//

import XCTest
import APIFeed
import FeatureFeed

class LoadCharacterFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URLRequest(url: URL(string: "https://a-given-url.com")!)
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_deliversSuccessWithItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = makeItem(id: 123, name: "name", description: "desc", modified: "ontem", resourceURI: "http://another-url.com", thumbnail: Thumbnail(path: "http://another-url.com", thumbnailExtension: "jpg"))
        
        let item2 = makeItem(id: 321, name: "algum", description: "muito tri", modified: "hoje", resourceURI: "http://another-url.com", thumbnail: Thumbnail(path: "http://some-url.com", thumbnailExtension: "jpg"))

        let items = [item1.model, item2.model]

        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URLRequest(url: URL(string: "http://any-url.com")!)
        let client = HTTPClientSpy()
        var sut: RemoteCharacterLoader? = RemoteCharacterLoader(url: url, client: client)

        var capturedResults = [RemoteCharacterLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URLRequest = URLRequest(url: URL(string: "https://a-url.com")!), file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteCharacterLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCharacterLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

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

    private func expect(_ sut: APIFeed.RemoteCharacterLoader, toCompleteWith expectedResult: Result<[FeatureFeed.Character], NetworkErrorCases>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as NetworkErrorCases), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }

}
