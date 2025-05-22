//
//  FontRegistrar.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 21.05.2025.
//

import Foundation
import CoreText

public final class FontRegistrar {

    public static func registerFonts() {
        Fonts.allFonts.forEach { fontName in
            registerFont(named: fontName)
        }
    }

}

private extension FontRegistrar {

    static func registerFont(named fontName: String) {
        guard let coreBundle = Bundle(identifier: "kapustin.Core") else {
            AppLogger.shared.logError("Core framework bundle not found")
            return
        }

        registerFont(named: fontName, in: coreBundle)
    }

    private static func registerFont(named fontName: String, in bundle: Bundle) {
            let fontExtensions = ["ttf", "otf"]

            for ext in fontExtensions {
                if let fontURL = bundle.url(forResource: fontName, withExtension: ext) {
                    var error: Unmanaged<CFError>?
                    if CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
                        AppLogger.shared.logSuccess("Successfully registered font: \(fontName)")
                        return
                    } else {
                        let errorDescription = error?.takeUnretainedValue().localizedDescription ?? "Unknown error"
                        AppLogger.shared.logError("Failed to register font \(fontName): \(errorDescription)")
                        return
                    }
                }
            }

            AppLogger.shared.logError("Font file \(fontName) not found in bundle")
        }

}
