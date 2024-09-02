//
//  PolybiusCipher.swift
//
//  https://en.wikipedia.org/wiki/Polybius_square
//
//  Created by ElysiaMae on 2024/8/26.
//

import Foundation

public struct PolybiusCipher {
    // i = j
    private let alphabet = [
        ["A", "B", "C", "D", "E"],
        ["F", "G", "H", "I", "K"],
        ["L", "M", "N", "O", "P"],
        ["Q", "R", "S", "T", "U"],
        ["V", "W", "X", "Y", "Z"]
    ]
    
    public init() {}
    
    private func findPosition(of letter: String) -> (Int, Int)? {
        for (rowIndex, row) in alphabet.enumerated() {
            if let colIndex = row.firstIndex(of: letter) {
                return (rowIndex + 1, colIndex + 1)
            }
        }
        return nil
    }
    
    public func encrypt(_ text: String) -> String {
        let uppercasedText = text.uppercased().replacingOccurrences(of: "J", with: "I")
        var encryptedText = ""
        
        for character in uppercasedText {
            if let position = findPosition(of: String(character)) {
                encryptedText += "\(position.0)\(position.1)"
            } else {
                encryptedText += String(character)
            }
        }
        
        return encryptedText
    }
    
    public func decrypt(_ code: String) -> String? {
        var decryptedText = ""
        var index = code.startIndex
        
        while index < code.endIndex {
            let rowIndex = code[index]
            let colIndex = code[code.index(after: index)]
            
            if let row = Int(String(rowIndex)), let col = Int(String(colIndex)) {
                decryptedText += alphabet[row - 1][col - 1]
            } else {
                return nil
            }
            
            index = code.index(index, offsetBy: 2)
        }
        
        return decryptedText
    }
}
