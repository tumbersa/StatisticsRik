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
        FontRegistrar.registerFonts()

        return true
    }

}
