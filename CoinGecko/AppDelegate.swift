//
//  AppDelegate.swift
//  CoinGecko
//
//  Created by Denis Shishmarev on 02.08.2025.
//

import UIKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        let listController = ListFactory().create()

        window?.rootViewController = UINavigationController(rootViewController: listController)
        window?.makeKeyAndVisible()

        return true
    }
}
