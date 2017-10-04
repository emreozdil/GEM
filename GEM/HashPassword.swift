//
//  HashPassword.swift
//  GEM
//
//  Created by Emre Özdil on 04/10/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import Foundation

class HashPassword {
    class func sha256(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
}
