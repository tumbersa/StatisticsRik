//
//  AppDelegate.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import Core
import UIKit
import OSLog

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerFonts()

        return true
    }

    private func registerFonts() {
        guard let fontURL = Bundle.main.url(forResource: "Gilroy-Bold", withExtension: "ttf") else {
            AppLogger.shared.logError("Файл шрифта не найден")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            AppLogger.shared.logError("Ошибка регистрации шрифта: \(error?.takeUnretainedValue().localizedDescription ?? "Unknown error")")
        }
    }
}

