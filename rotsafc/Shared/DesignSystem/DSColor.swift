//
//  DSColor.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import SwiftUI

/// Color tokens taken from the "After v2" frames in the Sketch file.
public enum DSColor {
    public static let brand = Color(hex: 0xD6336C)
    public static let brandTint = Color(hex: 0xD6336C, opacity: 0.15)
    public static let brandShadow = Color(hex: 0xD6336C, opacity: 0.08)

    public static let wallTop = Color(hex: 0xFFF7FA)
    public static let wallBottom = Color(hex: 0xFFEAF2)
    public static let ground = Color(hex: 0xFFDBE8)

    public static let clothesline = Color(hex: 0xA8A29E)
    public static let pegBody = Color(hex: 0xD8B88A)
    public static let pegSpring = Color(hex: 0xA98657)

    public static let noteYellow = Color(hex: 0xFFF59D)
    public static let notePeach = Color(hex: 0xFFC9A8)
    public static let noteMint = Color(hex: 0xB8F0D2)
    public static let noteLavender = Color(hex: 0xD9C8FA)

    public static let moodDrained = Color(hex: 0x9B8BD6)
    public static let moodDown = Color(hex: 0x6FA8DC)
    public static let moodOkay = Color(hex: 0xE9A27C)
    public static let moodGood = Color(hex: 0x5FBF96)
    public static let moodAmazing = Color(hex: 0xE8B93A)
}

extension Color {
    fileprivate init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
