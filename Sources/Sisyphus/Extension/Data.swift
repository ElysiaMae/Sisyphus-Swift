//
//  Data.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/8/30.
//

import Foundation

@available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
public extension Data {
    // MARK: Base64 Encoding
    
    /// Base64 Encoded to String
    /// alphabet= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    /// - Parameter alphabet: Base64 alphabet Table
    /// - Returns: string
    func sisyphusBase64Encoded(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/") -> String {
        guard alphabet.count == 64 else {
            // TODO: 错误处理
            return ""
        }
        
        var output = "" // The resulting Base64 encoded string. 最终的Base64编码字符串

        var buffer: UInt32 = 0 // Buffer to hold binary data as it's being processed. 用于保存正在处理的二进制数据的缓冲区
        var bufferLength = 0 // Number of bits currently held in the buffer. 缓冲区中当前保存的位数
                
        for byte in self {
            buffer = (buffer << 8) | UInt32(byte) // Shift buffer 8 bits left and add the new byte. 将缓冲区左移 8 位并添加新字节
            bufferLength += 8 // Increase buffer length by 8 bits. 缓冲区长度增加8位
                    
            while bufferLength >= 6 {
                let index = (buffer >> UInt32(bufferLength - 6)) & 0x3F // Extract top 6 bits to find the Base64 index. 提取最高的6位以找到Base64索引
                output.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(index))]) // Append the corresponding Base64 character. 添加相应的Base64字符
                bufferLength -= 6 // Reduce buffer length by 6 bits. 缓冲区长度减少6位
            }
        }
        
        // Handle remaining bits and padding
        if bufferLength > 0 {
            buffer <<= (6 - bufferLength)
            let index = buffer & 0x3F
            output.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(index))])
        }
                
        // Add padding if needed
        // 添加填充字符 '='
        let paddingCount = (3 - (self.count % 3)) % 3
        if paddingCount > 0 {
            output.append(String(repeating: "=", count: paddingCount))
        }

        return output
    }

    // MARK: Base64 URL Encoding
    
    /// Base64 URL 编码
    func sisyphusBase64URLEncoded(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_") -> String {
        guard alphabet.count == 64 else {
            // TODO: 错误处理
            return ""
        }
        
        var output = "" // The resulting Base64 encoded string. 最终的 Base64 编码字符串

        var buffer: UInt32 = 0 // Buffer to hold binary data as it's being processed. 用于保存正在处理的二进制数据的缓冲区
        var bufferLength = 0 // Number of bits currently held in the buffer. 缓冲区中当前保存的位数
                
        for byte in self {
            buffer = (buffer << 8) | UInt32(byte) // Shift buffer 8 bits left and add the new byte. 将缓冲区左移 8 位并添加新字节
            bufferLength += 8 // Increase buffer length by 8 bits. 缓冲区长度增加 8 位
                    
            while bufferLength >= 6 {
                let index = (buffer >> UInt32(bufferLength - 6)) & 0x3F // Extract top 6 bits to find the Base64 index. 提取最高的 6 位以找到 Base64 索引
                output.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(index))]) // Append the corresponding Base64 character. 添加相应的 Base64 字符
                bufferLength -= 6 // Reduce buffer length by 6 bits. 缓冲区长度减少 6 位
            }
        }
        
        // Handle remaining bits and padding
        if bufferLength > 0 {
            buffer <<= (6 - bufferLength)
            let index = buffer & 0x3F
            output.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(index))])
        }

        return output
    }
}
