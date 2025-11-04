//
//  ColorExtension.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

extension Color {
    static let mainColor = Color(red: 0x3B/255, green: 0x51/255, blue: 0x31/255)
    static let secondColor = Color(red: 0x76/255, green: 0x85/255, blue: 0x72/255)
    static let thirdColor = Color(red: 0xBC/255, green: 0xBF/255, blue: 0xB1/255)
    static let backgroundColor = Color(red: 0xF4/255, green: 0xF5/255, blue: 0xF7/255)
    static let tabbarColor = Color(red: 0x12/255, green: 0x18/255, blue: 0x10/255)
    static let tabbarButton = Color(red: 0x12/255, green: 0x18/255, blue: 0x10/255)
    
    static let knowledgeBackground = Color(red: 0xE8/255, green: 0xE6/255, blue: 0xE2/255)
    static let wetWasteColor = Color(red: 0x00/255, green: 0x93/255, blue: 0x45/255)
    static let wasteCard = Color(red: 0xD9/255, green: 0xD5/255, blue: 0xCF/255)
}

extension Font {
    
    static func noto(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .thin:
            return .custom("Noto Sans Thai Thin", size: size)
        case .light:
            return .custom("Noto Sans Thai Light", size: size)
        case .medium:
            return .custom("Noto Sans Thai Medium", size: size)
        case .semibold:
            return .custom("Noto Sans Thai SemiBold", size: size)
        case .bold:
            return .custom("Noto Sans Thai Bold", size: size)
        default:
            return .custom("Noto Sans Thai Regular", size: size)
        }
    }
    
}
