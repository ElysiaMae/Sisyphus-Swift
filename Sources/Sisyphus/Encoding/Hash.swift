//
//  Hash.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/8/30.
//

import CommonCrypto
import CryptoKit
import Foundation

// MARK: MD5

// public func md5Hash(_ string: String) -> String {
//    guard let inputData = string.data(using: .utf8) else {
//        return ""
//    }
//    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//
//    _ = inputData.withUnsafeBytes { buffer in
//        CC_MD5(buffer.baseAddress, CC_LONG(inputData.count), &digest)
//    }
//
//    var md5String = ""
//    for byte in digest {
//        md5String += String(format: "%02x", byte)
//    }
//
//    return md5String
// }

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func md5Hash(_ input: String) -> String {
    let inputData = Data(input.utf8)
    var hashed = Insecure.MD5.hash(data: inputData)

    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// MARK: - ShaHashAlgorithm

/// 可选的 Sha 散列函数
public enum ShaHashAlgorithm {
    case sha1
    case sha256
    case sha384
    case sha512
}

// MARK: Sha

/// sha 函数
/// - Parameters:
///   - input: 输入的字符串
///   - algorithm: sha 散列函数
/// - Returns: hash 后的字符串
@available(iOS 13.0, macOS 10.15.4, watchOS 6.0, tvOS 13.0, *)
public func shaHash(_ input: String, algorithm: ShaHashAlgorithm) -> String {
    let inputData = Data(input.utf8)
    var hashed: any Digest = switch algorithm {
        case .sha1:
            Insecure.SHA1.hash(data: inputData)
        case .sha256:
            SHA256.hash(data: inputData)
        case .sha384:
            SHA384.hash(data: inputData)
        case .sha512:
            SHA512.hash(data: inputData)
    }

    return hashed.compactMap { String(format: "%02x", $0) }.joined()
}

// TODO: Sha224

// TODO: RIPEMD, RIPEMD160

// MARK: File Hash

@available(iOS 13.0, macOS 10.15.4, watchOS 6.0, tvOS 13.0, *)
public func calculateFileSHA256(url: URL) async throws -> String {
    let bufferSize = 1024 * 1024 // 1 MB buffer
    var hash = SHA256()
    let fileSize = try FileManager.default.attributesOfItem(atPath: url.path)[.size] as! UInt64
    var processedSize: UInt64 = 0

    let fileHandle = try FileHandle(forReadingFrom: url)
    defer { try? fileHandle.close() }

    while autoreleasepool(invoking: {
        let data = try? fileHandle.read(upToCount: bufferSize)
        if let data, !data.isEmpty {
            hash.update(data: data)
            processedSize += UInt64(data.count)
            return true
        } else {
            return false
        }
    }) {}

    let digest = hash.finalize()
    return digest.map { String(format: "%02x", $0) }.joined()
}
