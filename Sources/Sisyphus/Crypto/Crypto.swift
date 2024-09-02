//
//  Crypto.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/2/19.
//

import CommonCrypto
import CryptoKit
import Foundation
import Security

// MARK: - CryptoError

public enum CryptoError: Error {
    case invalidInputData
    case invalidKeyOrNonce
    case decryptionFailed
}

// MARK: AES-GCM

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func aesGcmEncryptData(_ text: String, keyData: String, nonceData: String) -> String {
    // 解码 Base64 编码的密钥、nonce
    guard let key = base64Decode(keyData),
          let nonce = base64Decode(nonceData)
    else {
        return ""
    }

    if let encryptedData = try? aesGcmEncrypt(text: text, keyData: key, nonceData: nonce) {
        return encryptedData.base64EncodedString() // 将加密数据进行 base64
    } else {
        return ""
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func aesGcmEncrypt(text: String, keyData: Data, nonceData: Data) throws -> Data {
    let data = Data(text.utf8)
    let key = SymmetricKey(data: keyData)
    let nonce = try AES.GCM.Nonce(data: nonceData)
    let sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce)
    return sealedBox.ciphertext
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func aesGcmDecryptData(_ text: String, keyData: String, nonceData: String, tagData: String) -> String {
    // 将输入的字符串转换为 Data
    guard let ciphertextData = Data(base64Encoded: text),
          let key = Data(base64Encoded: keyData),
          let nonceData = Data(base64Encoded: nonceData),
          let tag = Data(base64Encoded: tagData)
    else {
        return ""
    }
    if let decrypted = try? aesGcmDecrypt(ciphertext: ciphertextData, keyData: key, nonceData: nonceData, tagData: tag) {
        if let decryptedString = String(data: decrypted, encoding: .utf8) {
            return decryptedString
        }
    } else {
        return ""
    }

    return ""
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public func aesGcmDecrypt(ciphertext: Data, keyData: Data, nonceData: Data, tagData: Data) throws -> Data {
    let key = SymmetricKey(data: keyData)
    let nonce = try AES.GCM.Nonce(data: nonceData)
    let tag = tagData

    let decrypted = try AES.GCM.open(AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag), using: key)

    return decrypted
}

//
// public func aesGcmDecrypt(sealedBox: AES.GCM.SealedBox, key: SymmetricKey) throws -> String {
//  let decryptedData = try AES.GCM.open(sealedBox, using: key)
//  guard let decryptedText = String(data: decryptedData, encoding: .utf8) else {
//    throw CryptoError.decryptionFailed
//  }
//  return decryptedText
// }

// MARK: AES-CBC

public func aesCBCEncrypt(text: String, key: Data, iv: Data) -> Data? {
    guard let data = text.data(using: .utf8) else {
        return nil
    }

    let dataLength = data.count
    let cryptLength = dataLength + kCCBlockSizeAES128
    var cryptData = Data(count: cryptLength)

    var numBytesEncrypted: size_t = 0

    let operation = CCOperation(kCCEncrypt)
    let algorithm = CCAlgorithm(kCCAlgorithmAES)
    let options = CCOptions(kCCOptionPKCS7Padding)
    let status = key.withUnsafeBytes { keyBytes in
        iv.withUnsafeBytes { ivBytes in
            data.withUnsafeBytes { dataBytes in
                cryptData.withUnsafeMutableBytes { cryptBytes in
                    CCCrypt(
                        operation,
                        algorithm,
                        options,
                        keyBytes.baseAddress, key.count,
                        ivBytes.baseAddress,
                        dataBytes.baseAddress, dataLength,
                        cryptBytes.baseAddress, cryptLength,
                        &numBytesEncrypted
                    )
                }
            }
        }
    }

    if status == kCCSuccess {
        cryptData.count = numBytesEncrypted
        return cryptData
    }
    return nil
}

// TODO: AES-ECB

// MARK: RSA

// 生成密钥对
func generateRSAKeyPair(keySize: Int = 2048) -> (SecKey, SecKey)? {
    let privateKeyAttributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits as String: keySize
    ]

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(privateKeyAttributes as CFDictionary, &error) else {
        print("Error creating private key: \(error.debugDescription)")
        return nil
    }

    let publicKey = SecKeyCopyPublicKey(privateKey)!
    return (publicKey, privateKey)
}

// 使用公钥加密数据
func encryptWithRSA(publicKey: SecKey, plainText: String) -> Data? {
    guard let plainData = plainText.data(using: .utf8) else {
        return nil
    }

    var error: Unmanaged<CFError>?
    let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, plainData as CFData, &error)
    return encryptedData as Data?
}

// 使用私钥解密数据
func decryptWithRSA(privateKey: SecKey, encryptedData: Data) -> String? {
    var error: Unmanaged<CFError>?
    let decryptedData = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA256, encryptedData as CFData, &error)
    return String(data: decryptedData! as Data, encoding: .utf8)
}

// MARK: 栅栏密码

/// 栅栏密码加密
/// - Parameters:
///   - text: <#text description#>
///   - rails: 栏数
/// - Returns: <#description#>
public func railFenceCipherEncrypt(_ text: String, rails: Int) -> String {
    ""
}

// MARK: RSA
