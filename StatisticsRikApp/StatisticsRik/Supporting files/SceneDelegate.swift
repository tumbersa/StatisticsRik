//
//  SceneDelegate.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import UIKit
import BuisnessLayer
import NetworkLayer
import DatabaseLayer

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = StatisticsViewController()
        viewController.statisticsDataProvider = StatisticsDataProvider(
            imageFetcher: ImageFetcher(),
            fetcher: Fetcher(),
            realmManager: RealmManager()
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

