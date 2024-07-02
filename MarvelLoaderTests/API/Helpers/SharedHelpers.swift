//
//  SharedHelpers.swift
//  MarvelLoaderTests
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation
import MarvelLoader

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURLRequest() -> URLRequest {
    return URLRequest(url: URL(string: "http://any-url.com")!)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyLocalThumbnail() -> LocalThumbnail {
    return LocalThumbnail(path: "https://any-url.com/image", thumbnailExtension: "jpg")
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json2 = ["results": items]
    let json = ["data": json2]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
