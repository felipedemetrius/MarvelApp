//
//  Encrypt.swift
//  MarvelLoader
//
//  Created by Felipe Demetrius Martins da Silva on 27/05/24.
//

import Foundation

struct Encrypt {
    static func toMD5(string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format: "%02x", byte)
        }
        return hexString
    }
}
