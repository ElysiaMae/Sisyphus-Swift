//
//  ZeroWidth.swift
//  Sisyphus
//
//  by https://github.com/yuanfux/zero-width-lib/
//
//  Created by ElysiaMae on 2024/9/1.
//

import Foundation

// MARK: - ZeroWidth

public enum ZeroWidth {
    // Zero-width character constants
    // 零宽字符常量定义
    private static let zeroWidthNonJoiner = "\u{200C}" // 零宽非连接符 Zero Width Non-Joiner
    private static let zeroWidthJoiner = "\u{200D}" // 零宽连接符 Zero Width Joiner
    private static let zeroWidthSpace = "\u{200B}" // 零宽空格 Zero Width Space
    private static let zeroWidthNoBreakSpace = "\u{FEFF}" // 零宽不换行空格 Zero Width No-Break Space
    private static let leftToRightMark = "\u{200E}" // 从左到右标记 Left-to-Right Mark
    private static let rightToLeftMark = "\u{200F}" // 从右到左标记 Right-to-Left Mark

    /// 零宽字符字典，用于将数字映射为零宽字符
    /// Dictionary for mapping digits to zero-width characters
    private static let zeroWidthDict: [String] = [
        leftToRightMark,
        rightToLeftMark,
        zeroWidthNonJoiner,
        zeroWidthJoiner,
        zeroWidthNoBreakSpace,
        zeroWidthSpace,
    ]

    // Array for mapping quinary (base 5) digits to zero-width characters
    // 从 5 进制到零宽字符的映射数组
//    private static let zeroWidthDict = Array(zeroWidthDict)

    /// Dictionary for mapping zero-width characters back to quinary digits
    /// 从零宽字符到 5 进制的反向映射字典
    private static let zeroToQuinaryMap: [String: String] = {
        var map = [String: String]()
        for (index, value) in zeroWidthDict.enumerated() {
            map[value] = "\(index)"
        }
        return map
    }()

    /// Split the text by inserting zero-width spaces between each character
    /// 使用零宽空格分隔文本中的每个字符
    /// - Parameter text: The text to be split
    /// - Returns: The split text
    public static func split(_ text: String) -> String {
        text.unicodeScalars.reduce(into: "") { result, character in
            result.append(Character(character))
            result.append(zeroWidthSpace)
        }
    }

    /// Encode hidden text into visible text
    /// 将隐藏文本编码到可见文本中
    /// - Parameters:
    ///   - visibleText: The visible text
    ///   - hiddenText: The text to be hidden
    /// - Returns: The encoded text with hidden content
    public static func encode(visibleText: String, hiddenText: String) -> String {
        let hiddenEncoded = t2z(hiddenText)
        guard !visibleText.isEmpty else { return hiddenEncoded }

        return visibleText.unicodeScalars.reduce(into: "") { result, character in
            result.append(Character(character))
            if result.count == 1 { // 将隐藏文本插入第一个字符之后 Insert hidden text after the first character
                result.append(contentsOf: hiddenEncoded)
            }
        }
    }

    /// Decode hidden text from encoded visible text
    /// 从编码的可见文本中解码隐藏文本
    /// - Parameter visibleText: The encoded visible text
    /// - Returns: The decoded hidden text
    public static func decode(_ visibleText: String) -> (visible: String, hidden: String) {
        let (visibleResult, hiddenResult) = visibleText.unicodeScalars.reduce(into: (visible: "", hidden: "")) { result, character in
            let characterString = String(character)
            // 分离可见字符和零宽字符
            if zeroToQuinaryMap[characterString] != nil {
                result.hidden.append(Character(character))
            } else {
                result.visible.append(Character(character))
            }
        }
        return (visible: visibleResult, hidden: z2t(hiddenResult))
    }

    /// Convert text into zero-width character encoding
    /// 将文本转换为零宽字符编码
    /// - Parameter text: The text to be converted
    /// - Returns: The converted zero-width character encoding
    private static func t2z(_ text: String) -> String {
        String(text.unicodeScalars.reduce(into: "") { zeroWidthText, scalar in
            let base5Representation = String(scalar.value, radix: 5)
            let zeroWidthRepresentation = base5Representation.compactMap { digit in
                zeroWidthDict[Int(String(digit))!]
            }.joined()
            zeroWidthText.append(zeroWidthRepresentation)
            zeroWidthText.append(zeroWidthSpace)
        }.dropLast()) // 移除最后一个零宽空格 Remove the last zero-width space
    }

    /// Convert zero-width character encoding back into text
    /// 将零宽字符编码转换回文本
    /// - Parameter zeroWidthText: The zero-width character encoded text
    /// - Returns: The decoded text
    private static func z2t(_ zeroWidthText: String) -> String {
        guard !zeroWidthText.isEmpty else { return "" }

        return zeroWidthText
            .components(separatedBy: zeroWidthSpace)
            .compactMap { component in
                let base5Representation = component.compactMap { character in
                    zeroToQuinaryMap[String(character)]
                }.joined()
                return Int(base5Representation, radix: 5).flatMap { String(UnicodeScalar($0)!) }
            }
            .joined()
    }
}
