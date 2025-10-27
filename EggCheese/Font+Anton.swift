//
//  Font+Anton.swift
//  EggCheese
//
//  Created by Fora on 24.10.2025.
//

import SwiftUI

extension Font {
    static func anton(_ size: CGFloat) -> Font {
        return Font.custom("Anton-Regular", size: size)
    }
    
    static func anton(_ style: Font.TextStyle) -> Font {
        switch style {
        case .largeTitle:
            return Font.custom("Anton-Regular", size: 34)
        case .title:
            return Font.custom("Anton-Regular", size: 28)
        case .title2:
            return Font.custom("Anton-Regular", size: 22)
        case .title3:
            return Font.custom("Anton-Regular", size: 20)
        case .headline:
            return Font.custom("Anton-Regular", size: 17)
        case .body:
            return Font.custom("Anton-Regular", size: 17)
        case .callout:
            return Font.custom("Anton-Regular", size: 16)
        case .subheadline:
            return Font.custom("Anton-Regular", size: 15)
        case .footnote:
            return Font.custom("Anton-Regular", size: 13)
        case .caption:
            return Font.custom("Anton-Regular", size: 12)
        case .caption2:
            return Font.custom("Anton-Regular", size: 11)
        @unknown default:
            return Font.custom("Anton-Regular", size: 17)
        }
    }
}
