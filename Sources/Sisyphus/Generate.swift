//
//  Generate.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/8/31.
//

import Foundation

// MARK: UUID

/// 生成 UUID
/// - Returns: UUID String
public func generateUUID() -> String {
    UUID().uuidString
}

public func generateUUIDs(_ count: Int = 0) -> [UUID] {
    (0 ..< count).map { _ in UUID() }
}

public func generateUUIDsString(_ count: Int = 0) -> [String] {
    (0 ..< count).map { _ in UUID().uuidString }
}

// MARK: User-Agent

/// 随机生成一个 User-Agent
/// - Returns: User-Agent String
public func generateRandomUserAgent() -> String {
    let osVersions = ["Windows NT 10.0; Win64; x64", "iPhone; CPU iPhone OS 14_6 like Mac OS X", "Linux; Android 8.1.0; SAMSUNG SM-A9080", "Linux; Android 10; Mi 10 Pro", "iPad; CPU iPad OS 10_3_4 like Mac OS X", "iPad; CPU iPad OS 14_2_1 like Mac OS X"]
    let browserVersions = ["Chrome/91.0.4472.124 Safari/537.36", "Safari/537.36", "Mobile/15E148 Safari/604.1", "Chrome/110.0.5481.63 Mobile Safari/537.36"]
    let webKitVersion = ["AppleWebKit/535.35.2", "AppleWebKit/535.8.4", "AppleWebKit/533.10.4", "AppleWebKit/535.2", " AppleWebKit/533.0", "AppleWebKit/605.1.15"]

    // 随机选择一个操作系统版本和一个浏览器版本
    let randomOSVersion = osVersions.randomElement() ?? ""
    let randomBrowserVersion = browserVersions.randomElement() ?? ""
    let randomWebKitVersion = webKitVersion.randomElement() ?? ""

    // 构建 User-Agent 字符串
    let userAgent = "Mozilla/5.0 (\(randomOSVersion)) \(randomWebKitVersion) (\(randomBrowserVersion))"

    return userAgent
}

public func generateRandomUserAgents(_ count: Int = 0) -> [String] {
    (0 ..< count).map { _ in generateRandomUserAgent() }
}
