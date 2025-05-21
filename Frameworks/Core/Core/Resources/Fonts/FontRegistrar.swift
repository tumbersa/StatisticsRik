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
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            AppLogger.shared.logError("Файл шрифта \(fontName) не найден")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            let errorDescription = error?.takeUnretainedValue().localizedDescription ?? "Unknown error"
            AppLogger.shared.logError("Ошибка регистрации шрифта \(fontName): \(errorDescription)")
        }
    }

}
