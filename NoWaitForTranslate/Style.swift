//
//  Style.swift
//  NoWaitForTranslate
//
//  Created by Ivan Ermolaev on 03/08/2021.
//

import Foundation
import SwiftUI

struct NWFTStyleColors {
    static let primaryBackgroundColor = Color(red: 254 / 255, green: 233 / 255, blue: 225 / 255)
    static let primaryDarkBackgroundColor = Color(red: 250 / 255, green: 212 / 255, blue: 192 / 255)
    static let secondBackgroudColor = Color(red: 100 / 255, green: 182 / 255, blue: 172 / 255)
    static let secondAlternateColor = Color(red: 192 / 255, green: 253 / 255, blue: 251 / 255)
    static let darkColor = Color(red: 176 / 255, green: 158 / 255, blue: 153 / 255)
    static let darkColor2 = Color(red: 156 / 255, green: 138 / 255, blue: 133 / 255)
    static let deleteColor = Color(red: 250 / 255, green: 128 / 255, blue: 114 / 255)
}

struct NWFTFonts {
    static let primaryFontName = "RacingSansOne-Regular"
    static let secondaryFontName = "Georama-SemiBold"
    
    static var primaryFontCache: [CGFloat:Font] = [:]
    static var secondaryFontCache: [CGFloat:Font] = [:]
    
    static func primaryFont(withSize size: CGFloat) -> Font {
        if let font = primaryFontCache[size] {
            return font
        } else {
            let newFont = Font.custom(primaryFontName, size: size)
            primaryFontCache[size] = newFont
            return newFont
        }
    }
    static func secondaryFont(withSize size: CGFloat) -> Font {
        if let font = secondaryFontCache[size] {
            return font
        } else {
            let newFont = Font.custom(secondaryFontName, size: size)
            secondaryFontCache[size] = newFont
            return newFont
        }
    }
}

struct NWFTLayouts {
    static var border = 0.0
}

struct NWFTUtils {
    
    static let countryIcons = [
        "nl": "🇳🇱",
        "us": "🇺🇸",
        "uk": "🇬🇧",
        "en": "🇬🇧",
        "ru": "🇷🇺",
        "es": "🇪🇸",
    ]
    
    static let defaultFlagIcon = "🏁"
    
    static func flagIcon(withCode languageCode: String) -> String {
        if let icon = NWFTUtils.countryIcons[languageCode] {
            return icon
        } else {
            return NWFTUtils.defaultFlagIcon;
        }
    }
}
