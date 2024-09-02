//
//  URLEncoding.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/7/31.
//

import Foundation

// MARK: URL

/// URL 编码
/// - Parameter text: 待编码字符串
/// - Returns: <#description#>
public func urlEncode(_ text: String) -> String? {
    let allowedCharacterSet = CharacterSet.urlQueryAllowed
    let encodedString = text.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    return encodedString
}

public func urlDecode(_ urlString: String) -> String? {
    if let decodedString = urlString.removingPercentEncoding {
        decodedString
    } else {
        nil
    }
}
