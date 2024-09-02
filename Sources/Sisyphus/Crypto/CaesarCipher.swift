//
//  CaesarCipher.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/2/19.
//

import Foundation

// MARK: 凯撒密码

/// 凯撒密码加密
/// - Parameters:
///   - text: <#text description#>
///   - rotn: 偏移量
/// - Returns: <#description#>
public func caesarCipherEncrypt(_ text: String, rotn: Int) -> String {
    var result = ""

    for c in text {
        // 判断是不是字母
        if c.isLetter {
            let ascii = c.asciiValue!
            var shiftedValue = ascii + UInt8(rotn)
            // 检查新的 ASCII 值是否超出了字母的范围
            if c.isUppercase {
                if shiftedValue > UnicodeScalar("Z").value {
                    shiftedValue -= 26
                }
            } else {
                if shiftedValue > UnicodeScalar("z").value {
                    shiftedValue -= 26
                }
            }
            // 将新的 ASCII 值转换回字符，并附加到结果字符串中
            let shiftedChar = Character(UnicodeScalar(shiftedValue))
            result.append(shiftedChar)
        }
        // 如果不是字母
        else {
            result.append(c)
        }
    }

    return result
}

/// 凯撒密码穷举解密
/// - Parameter text: <#text description#>
/// - Returns: 所有可能的结果列表
public func caesarCipherDecrypt(_ text: String) -> [String] {
    var resultList = [String]()
    for rotn in 1 ... 25 {
        var result = ""

        for c in text {
            // 判断是不是字母
            if c.isLetter {
                let ascii = c.asciiValue!
                var shiftedValue = ascii - UInt8(rotn)
                // 检查新的 ASCII 值是否超出了字母的范围
                if c.isUppercase {
                    if shiftedValue < UnicodeScalar("A").value {
                        shiftedValue += 26
                    }
                } else {
                    if shiftedValue < UnicodeScalar("a").value {
                        shiftedValue += 26
                    }
                }
                // 将新的 ASCII 值转换回字符，并附加到结果字符串中
                let shiftedChar = Character(UnicodeScalar(shiftedValue))
                result.append(shiftedChar)
            }
            // 如果不是字母
            else {
                result.append(c)
            }
        }
        resultList.append(result)
    }
    return resultList
}

// MARK: Rot13 Cipher

/// Rot13 加密
/// - Parameter text: <#text description#>
/// - Returns: <#description#>
public func rot13CipherEncrypt(_ text: String) -> String {
    caesarCipherEncrypt(text, rotn: 13)
}


