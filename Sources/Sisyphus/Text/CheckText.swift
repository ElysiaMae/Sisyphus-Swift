//
//  CheckText.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/9/2.
//

import Foundation

public extension String {
    /// Show All Unicode Characters
    /// 显示所有的不可见 Unicode 字符
    /// - Returns:
    func showAllUnicodeCharacters() -> String {
        let unicodeCharacters: Set<UInt32> = [
            // Zero Width Characters 零宽字符
            0x200B, // Zero Width Space 零宽空格
            0x200C, // Zero Width Non-Joiner 零宽非连接符
            0x200D, // Zero Width Joiner 零宽连接符
            0xFEFF, // Zero Width No-Break Space 零宽不换行空格
            // Invisible Format Control Characters 不可见格式控制字符
            0x200E, // Left-to-Right Mark 从左到右标记
            0x200F, // Right-to-Left Mark 从右到左标记
            0x202A, // Left-to-Right Embedding
            0x202B, // Right-to-Left Embedding
            0x202D, // Left-to-Right Override
            0x202E, // Right-to-Left Override
            0x202C, // Pop Directional Formatting
            // Whitespace Characters
            0x0020, // Space
            0x0009, // Tab
            0x000A, // Newline
            0x000D, // Carriage Return
            0x00A0, // Non-Breaking Space
            // Control Characters
            0x0000, // Null
            0x0007, // Bell
            0x0008, // Backspace
            0x000C, // Form Feed
            0x001B, // Escape
            0x007F, // Delete
            // Separator Characters
            0x2028, // Line Separator
            0x2029, // Paragraph Separator
            // Other
            0x00AD, // Soft Hyphen
            0xFFFC, // Object Replacement Character
            0xFFF9, // Start
            0xFFFA, // Continue
            0xFFFB, // End
        ]
        var result = ""

        for scalar in unicodeScalars {
            if unicodeCharacters.contains(scalar.value) {
                // 将零宽字符转换为 Unicode 编码形式
                result += "\\u{\(String(format: "%04X", scalar.value))}"
            } else {
                result += String(scalar)
            }
        }

        return result
    }
}
