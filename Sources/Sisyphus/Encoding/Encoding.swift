//
//  Encoding.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/7/17.
//

import Foundation

// MARK: HTML

/// HTML 编码
/// - Parameter text: 待编码字符串
/// - Returns: description
public func htmlEncode(_ text: String) -> String? {
    var encodedString = ""
    for scalar in text.unicodeScalars {
        switch scalar.value {
            case 32: // 空格
                encodedString += "&nbsp;"
            case 34: // "
                encodedString += "&quot;"
            case 38: // &
                encodedString += "&amp;"
            case 39: // '
                encodedString += "&apos;"
            case 60: // <
                encodedString += "&lt;"
            case 62: // >
                encodedString += "&gt;"
            default:
                encodedString.append(Character(scalar))
        }
    }
    return encodedString
}

/// HTML 解码
/// - Parameter htmlString: htmlString description
/// - Returns: description
public func htmlDecode(_ htmlString: String) -> String? {
    nil
}
