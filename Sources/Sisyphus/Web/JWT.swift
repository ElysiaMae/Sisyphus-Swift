//
//  JWT.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/8/3.
//

import CryptoKit
import Foundation

// Supported Algorithm Enumeration
public enum JWTAlgorithm: String, CaseIterable {
    case HS256, HS384, HS512
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct JWT {
    // 用于 HMAC 签名的密钥
    private var secret: String
    private var algorithm: JWTAlgorithm

    public init(secret: String) {
        self.secret = secret
        self.algorithm = JWTAlgorithm.HS256
    }

    public init(secret: String, algorithm: JWTAlgorithm) {
        self.secret = secret
        self.algorithm = algorithm
    }

    /// Encode Function
    /// - Parameter payload: <#payload description#>
    /// - Returns: <#description#>
    public func encode(payload: [String: Any]) -> String? {
        // JWT Header
        let header = ["alg": algorithm.rawValue, "typ": "JWT"]

        // Convert Header and Payload to JSON Data
        // Header eg: {"typ":"JWT","alg":"HS256"}
        guard let headerData = try? JSONSerialization.data(withJSONObject: header, options: []),
              let payloadData = try? JSONSerialization.data(withJSONObject: payload, options: [])
        else {
            return nil
        }

        // Convert Header and Payload to Base64URL Encoded Strings
        let headerString = headerData.sisyphusBase64URLEncodedString()
        let payloadString = payloadData.sisyphusBase64URLEncodedString()

        // Combine Header and Payload into String to be Signed
        let signingInput = "\(headerString).\(payloadString)"
        // Choose Corresponding HMAC Algorithm for Signing Based on Algorithm
        var signatureString: String?

        // Choose Corresponding HMAC Algorithm for Signing Based on Algorithm
        switch algorithm {
        case .HS256:
            let signature = HMAC<SHA256>.authenticationCode(for: Data(signingInput.utf8), using: SymmetricKey(data: Data(secret.utf8)))
            signatureString = Data(signature).base64EncodedString()
        case .HS384:
            let signature = HMAC<SHA384>.authenticationCode(for: Data(signingInput.utf8), using: SymmetricKey(data: Data(secret.utf8)))
            signatureString = Data(signature).base64EncodedString()
        case .HS512:
            let signature = HMAC<SHA512>.authenticationCode(for: Data(signingInput.utf8), using: SymmetricKey(data: Data(secret.utf8)))
            signatureString = Data(signature).base64EncodedString()
//        default:
//            return nil
        }

        // Convert Signature to Base64URL Encoded String
        signatureString = signatureString?.replacingOccurrences(of: "=", with: "").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "+", with: "-")

        // Return Complete JWT String
        return "\(signingInput).\(signatureString ?? "")"
    }

    /// Decode Function
    /// - Parameter jwt: <#jwt description#>
    /// - Returns: <#description#>
    public func decode(jwt: String) -> (header: [String: Any], payload: [String: Any], signature: String)? {
        let segments = jwt.split(separator: ".")

        // Ensure JWT String has Three Parts: Header, Payload, and Signature
        guard segments.count == 3,
              // 将 Base64URL 中的 _ 替换为标准 Base64 中的 /，将 Base64URL 中的 - 替换为标准 Base64 中的 +
//              let headerData = Data(base64Encoded: String(segments[0])),
              let headerData = Data.sisyphusBase64URLDecodedString(String(segments[0])),
//              let payloadData = Data(base64Encoded: String(segments[1])),
              let payloadData = Data.sisyphusBase64URLDecodedString(String(segments[1])),
//              let signature = Data(base64Encoded: String(segments[2]))
              let signature = Data.sisyphusBase64URLDecodedString(String(segments[2]))
        else {
            return nil
        }

        // Combine Header and Payload for Signature Verification
        let signingInput = "\(segments[0]).\(segments[1])"
        var expectedSignature: Data?

        // Choose Corresponding HMAC Algorithm for Signature Verification Based on Algorithm
        switch algorithm {
        case .HS256:
            expectedSignature = Data(HMAC<SHA256>.authenticationCode(for: Data(signingInput.utf8), using: SymmetricKey(data: Data(secret.utf8))))
        case .HS384:
            expectedSignature = Data(HMAC<SHA384>.authenticationCode(for: Data(signingInput.utf8), using: SymmetricKey(data: Data(secret.utf8))))
        case .HS512:
            expectedSignature = Data(HMAC<SHA512>.authenticationCode(for: Data(signingInput.utf8), using: SymmetricKey(data: Data(secret.utf8))))
//        default:
//            return nil
        }

        // Convert Header and Payload from JSON Data to Dictionary
        guard let header = try? JSONSerialization.jsonObject(with: headerData, options: []) as? [String: Any],
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any]
        else {
            return nil
        }

        print(header)
        print(payload)

        // 验证签名是否匹配 / Verify if Signature Matches
        guard expectedSignature == signature else {
            return nil
        }

        // 返回头部、载荷和签名 / Return Header, Payload, and Signature
        return (header, payload, segments[2].description)
    }
}
