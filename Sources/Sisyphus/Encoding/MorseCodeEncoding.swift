//
//  MorseCodeEncoding.swift
//  Sisyphus
//
//  Created by ElysiaMae on 2024/8/30.
//

import Foundation

// MARK: Morse

public class MorseCode {
    // 定义字符到莫尔斯码的映射
    private let morseCodeDict: [Character: String] = [
        "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
        "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
        "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
        "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
        "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
        "Z": "--..",
        "0": "-----", "1": ".----", "2": "..---", "3": "...--", "4": "....-",
        "5": ".....", "6": "-....", "7": "--...", "8": "---..", "9": "----.",
        ".": ".-.-.-", ",": "--..--", "?": "..--..", "'": ".----.", "!": "-.-.--",
        "/": "-..-.", "(": "-.--.", ")": "-.--.-", "&": ".-...", ":": "---...",
        ";": "-.-.-.", "=": "-...-", "+": ".-.-.", "-": "-....-", "_": "..--.-",
        "\"": ".-..-.", "$": "...-..-", "@": ".--.-."
    ]

    public init() {}

    public func encode(_ text: String) -> String {
        let uppercasedText = text.uppercased()
        var morseCode = ""
        for char in uppercasedText {
            if let code = morseCodeDict[char] {
                morseCode += code + " "
            } else {
                // 对于不支持的字符，用空格代替
                morseCode += " "
            }
        }
        return morseCode
    }

    public func decode(_ text: String) -> String {
        var decodedText = ""
        let morseCodeArray = text.components(separatedBy: " ")
        for code in morseCodeArray {
            for (char, morse) in morseCodeDict {
                if code == morse {
                    decodedText += String(char)
                }
            }
        }
        return decodedText
    }
}
