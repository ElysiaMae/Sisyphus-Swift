//
//  BaseEncoding.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/7/31.
//

import Foundation

// MARK: Base16

/// base16 编码
/// - Parameter text: 待编码字符串
/// - Returns: 编码完字符串
public func base16Encode(_ text: String) -> String? {
    let data = text.data(using: .utf8)
    return data?.map { String(format: "%02hhX", $0) }.joined()
}

/// base16 解码
/// - Parameter text: 待解码字符串
/// - Returns: 解码完字符串
public func base16Decode(_ text: String) -> String? {
    var cleanedText = text
    // 去掉可能存在的非法字符
    cleanedText = cleanedText.replacingOccurrences(of: "[^0-9a-fA-F]", with: "", options: .regularExpression)
    // 检查长度是否为偶数
    guard cleanedText.count % 2 == 0 else {
        return nil
    }
    var bytes = [UInt8]()
    var currentIndex = cleanedText.startIndex
    while currentIndex < cleanedText.endIndex {
        let endIndex = cleanedText.index(currentIndex, offsetBy: 2)
        if let byte = UInt8(cleanedText[currentIndex ..< endIndex], radix: 16) {
            bytes.append(byte)
        } else {
            return nil // 无法解析的十六进制字符
        }
        currentIndex = endIndex
    }
    return String(bytes: bytes, encoding: .utf8)
}

// MARK: Base32

/// base32 编码
/// - Parameter text: 待编码字符串
/// - Returns: <#description#>
public func base32Encode(_ text: String) -> String? {
    guard let data = text.data(using: .utf8) else {
        return nil
    }

    let base32Chars: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")

    var result = ""
    var currentByte: UInt8 = 0
    var bitsRemaining: UInt8 = 8

    // 遍历输入数据的每个字节
    for byte in data {
        // 将当前字节左移 8 位，然后与当前字节进行按位或运算
        currentByte <<= 8
        currentByte |= byte
        bitsRemaining += 8

        // 当剩余比特数大于等于 5 时，进行编码
        while bitsRemaining >= 5 {
            let index = (currentByte >> (bitsRemaining - 5)) & 0x1F
            result.append(base32Chars[Int(index)])
            bitsRemaining -= 5
        }
    }
    // 处理剩余的比特位，不足 5 位的话补充 0 并进行编码
    if bitsRemaining > 0 {
        let index = (currentByte << (5 - bitsRemaining)) & 0x1F
        result.append(base32Chars[Int(index)])
    }

    // 确保结果的长度是 8 的倍数，如果不是，添加 '=' 补充
    while result.count % 8 != 0 {
        result.append("=")
    }

    return result
}

/// base32 解码
/// - Parameter text: <#text description#>
/// - Returns: <#description#>
public func base32Decode(_ text: String) -> String? {
    let base32Chars: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")

    var result = Data()
    var currentByte: UInt8 = 0
    var bitsRemaining: UInt8 = 0

    // 遍历输入的 Base32 编码字符串
    for char in text {
        // 查找字符在 Base32 字符集中的索引
        if let index = base32Chars.firstIndex(of: char) {
            // 将当前字节左移 5 位，然后与当前字节进行按位或运算
            currentByte <<= 5
            currentByte |= UInt8(index)
            bitsRemaining += 5

            // 当剩余比特数大于等于 8 时，进行解码
            if bitsRemaining >= 8 {
                let byte = (currentByte >> (bitsRemaining - 8)) & 0xFF
                result.append(byte)
                bitsRemaining -= 8
            }
        }
    }

    return String(data: result, encoding: .utf8)
}

// TODO: Base36
// TODO: Base58
// TODO: Base62

// MARK: Base64

/// base64 编码
/// - Parameter text: 待编码字符串
/// - Returns: <#description#>
public func base64EncodeData(_ text: String) -> String? {
    guard let data = text.data(using: .utf8) else {
        return nil
    }

    return base64Encode(data)
}

public func base64Encode(_ text: Data) -> String? {
    text.base64EncodedString()
}

/// base64 解码
public func base64DecodeData(_ text: String) -> String? {
    if let data = base64Decode(text) {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

public func base64Decode(_ text: String) -> Data? {
    guard let data = Data(base64Encoded: text) else {
        return nil
    }

    return data
}

// MARK: Base85

/// base85 编码
/// - Parameter text: 待编码字符串
/// - Returns: <#description#>
public func base85Encode(_ text: String) -> String? {
    guard let data = text.data(using: .utf8) else {
        return nil
    }
    let base85Chars = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~")
    var encoded = ""
    var currentByte: UInt32 = 0
    var bitsRemaining: UInt8 = 0

    for byte in data {
        currentByte <<= 8
        currentByte |= UInt32(byte)
        bitsRemaining += 8

        while bitsRemaining >= 5 {
            let index = (currentByte >> (bitsRemaining - 5)) & 0x1F
            encoded.append(base85Chars[Int(index)])
            bitsRemaining -= 5
        }
    }

    // 处理剩余的不足 5 位的字节
    if bitsRemaining > 0 {
        currentByte <<= (5 - bitsRemaining)
        let index = currentByte & 0x1F
        encoded.append(base85Chars[Int(index)])
    }

    return encoded
}

/// base85 解码
/// - Parameter text: <#text description#>
/// - Returns: <#description#>
public func base85Decode(_ text: String) -> String? {
    let base85Chars = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~")
    var decoded = Data()
    var currentByte: UInt32 = 0
    var bitsRemaining: UInt8 = 0

    for char in text {
        if let index = base85Chars.firstIndex(of: char) {
            currentByte <<= 5
            currentByte |= UInt32(index)
            bitsRemaining += 5

            if bitsRemaining >= 8 {
                let byte = (currentByte >> (bitsRemaining - 8)) & 0xFF
                decoded.append(UInt8(byte))
                bitsRemaining -= 8
            }
        }
    }

    return String(data: decoded, encoding: .utf8)
}

// TODO: Base91
// TODO: Base92
