//
//  String.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/9/16.
//

import Foundation

@available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
public extension String {
    // MARK: Base64 Encoding to String
    
    /// Base64 Encoded to String
    /// alphabet= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    /// - Parameter alphabet: Base64 alphabet Table
    /// - Parameter strict: strict mode
    /// - Returns: String?
    func sisyphusBase64EncodedString(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", strict: Bool = true) -> String? {
        var result = self
        if strict {
            result.removeAll(keepingCapacity: true) // 重置字符串保留字符串容量
            let set = Set(alphabet)
            for char in self {
                if set.contains(char) {
                    result.append(char)
                }
            }
        }
        
        guard let data = result.data(using: .utf8) else {
            return nil
        }
        
        return data.sisyphusBase64Encoded(alphabet: alphabet)
    }
    
    /// Base64 Decoded to String
    /// alphabet= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    /// - Parameter alphabet: Base64 alphabet Table
    /// - Returns: String?
    func sisyphusBase64DecodedString(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", strict: Bool = true) -> String? {
        var result = self
        if strict {
            result.removeAll(keepingCapacity: true) // 重置字符串保留字符串容量
            let set = Set(alphabet)
            for char in self {
                if set.contains(char) {
                    result.append(char)
                }
            }
        }
        
        if let data = result.sisyphusBase64Decoded(alphabet: alphabet) {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    // MARK: Base64 Encoding

    /// Base64 Decoded to Data
    /// - Parameter alphabet: Base64 alphabet Table
    /// - Returns: Data?
    func sisyphusBase64Decoded(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/") -> Data? {
        guard alphabet.count == 64 else {
            // TODO: 错误处理
            return nil
        }
        
        var output = [UInt8]() // The resulting Base64 decoded byte arr. 最终的Base64解码字节数组
        
        var buffer: UInt32 = 0 // Buffer to hold binary data as it's being processed. 用于保存正在处理的二进制数据的缓冲区
        var bufferLength = 0 // Number of bits currently held in the buffer. 缓冲区中当前保存的位数
        
        let base64String = self.filter { $0 != "=" }
        
        for byte in base64String {
            guard let index = alphabet.firstIndex(of: byte) else { return nil }
            let value = alphabet.distance(from: alphabet.startIndex, to: index)
            
            // 将每个 Base64 字符转换为 6 位数据并累加到缓冲区
            buffer = (buffer << 6) | UInt32(value)
            bufferLength += 6
            
            // 每次提取完整的 8 位字节
            if bufferLength >= 8 {
                let byte = UInt8((buffer >> (bufferLength - 8)) & 0xFF)
                bufferLength -= 8
                output.append(byte)
            }
        }
        
        return Data(output)
    }
    
    // MARK: Base64 URL Encoding to String
    
    /// Base64 URL Encoded to String
    /// alphabet= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    /// - Parameter alphabet: Base64 alphabet Table
    /// - Parameter strict: strict mode
    /// - Returns: String?
    func sisyphusBase64URLEncodedString(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", strict: Bool = true) -> String? {
        var result = self
        if strict {
            result.removeAll(keepingCapacity: true) // 重置字符串保留字符串容量
            let set = Set(alphabet)
            for char in self {
                if set.contains(char) {
                    result.append(char)
                }
            }
        }
        
        guard let data = result.data(using: .utf8) else {
            return nil
        }
        
        return data.sisyphusBase64URLEncoded(alphabet: alphabet)
    }
    
    /// Base64 URL Decoded to String
    /// alphabet= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    /// - Parameter alphabet: Base64 alphabet Table
    /// - Returns: String?
    func sisyphusBase64URLDecodedString(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", strict: Bool = true) -> String? {
        var result = self
        if strict {
            result.removeAll(keepingCapacity: true) // 重置字符串保留字符串容量
            let set = Set(alphabet)
            for char in self {
                if set.contains(char) {
                    result.append(char)
                }
            }
        }
        
        if let data = result.sisyphusBase64URLDecoded(alphabet: alphabet) {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    // MARK: Base64 URL Encoding
    
    func sisyphusBase64URLDecoded(alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_") -> Data? {
        guard alphabet.count == 64 else {
            // TODO: 错误处理
            return nil
        }
        
        var output = [UInt8]() // The resulting Base64 decoded byte arr. 最终的 Base64 解码字节数组
        
        var buffer: UInt32 = 0 // Buffer to hold binary data as it's being processed. 用于保存正在处理的二进制数据的缓冲区
        var bufferLength = 0 // Number of bits currently held in the buffer. 缓冲区中当前保存的位数
        
        for byte in self {
            guard let index = alphabet.firstIndex(of: byte) else { return nil }
            let value = alphabet.distance(from: alphabet.startIndex, to: index)
            
            // 将每个 Base64 字符转换为 6 位数据并累加到缓冲区
            buffer = (buffer << 6) | UInt32(value)
            bufferLength += 6
            
            // 每次提取完整的 8 位字节
            if bufferLength >= 8 {
                let byte = UInt8((buffer >> (bufferLength - 8)) & 0xFF)
                bufferLength -= 8
                output.append(byte)
            }
        }
        
        return Data(output)
    }
}
