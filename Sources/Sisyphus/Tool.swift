//
//  Tool.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/8/30.
//

import Foundation

/// 判断文件大小
/// - Parameters:
///   - url: File URL
///   - size: File Size, default 10MB
/// - Returns: Bool
public func isValidateFileSize(_ url: URL, _ size: Int = 10 * 1024 * 1024) throws -> Bool {
    do {
        let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
        if let fileSize = resourceValues.fileSize {
            return fileSize <= size
        }
    } catch {
        throw error
    }
    return false
}
