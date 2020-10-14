//
//  Constants.swift
//  RfWK
//
//  Created by Florian Nöhring on 07.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import UIKit

class Constants {

    // MARK: - Identifiers
    static let defaultsKeyForPersonalAccessToken: String = "WANI_KANI_API_V2"
    static let launchArgumentForTestTarget = "-test"
    static let userDefaultsTestSuiteName = "\(String(describing: Bundle.main.bundleIdentifier!)).Test"
    static let sqliteFileName = "RfWK.sqlite"
    static let sqliteTestFileName = "RfWK_test.sqlite"
    static let defaultsKeyForPracticeSessionSettingsFilter = "PracticeSessionSettingsFilter"
    static let defaultsKeyForPracticeSessionSettingsLength = "PracticeSessionSettingsLength"
    
    // MARK: - Sizes
    static let colorStripeWidth = CGFloat(4.0)
    static let colorBannerWidth = CGFloat(7.0)
    
    // MARK: - Font sizes
    static let veryLargeFontsize = CGFloat(26)
    static let titleFontsize = CGFloat(18)
    static let defaultFontsize = CGFloat(16)
    static let smallFontsize = CGFloat(15)
    static let verySmallFontsize = CGFloat(10)
    
    
    enum FontSize: CGFloat {
        case largeTitle = 48
        case smallTitle = 36
        case veryLarge = 26.0
        case japaneseTableContent = 20
        case large = 18.0
        case standard = 16.0 // system default
        case small = 15.0
        case tiny = 10.0
    }
    
    enum Font {
        case system
        case script
        case japaneseSerif
    }
    
    static func font(font: Font, size: FontSize) -> UIFont {
        switch font {
            case .system:
                return UIFont.systemFont(ofSize: size.rawValue)
            case .japaneseSerif:
                return UIFont.init(name: "HiraMinProN-W3", size: size.rawValue)!
            case .script:
                return UIFont.init(name: "ChalkboardSE-Light", size: size.rawValue)!
        }
    }
}
