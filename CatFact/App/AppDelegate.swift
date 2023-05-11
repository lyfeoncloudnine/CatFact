//
//  AppDelegate.swift
//  CatFact
//
//  Created by lyfeoncloudnine on 2023/05/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootViewController()
        return true
    }
}

private extension AppDelegate {
    func setRootViewController() {
        let catFactViewController = CatFactViewController()
        catFactViewController.reactor = CatFactViewReactor(apiService: APIService())
        
        let initialWindow = UIWindow(frame: UIScreen.main.bounds)
        initialWindow.rootViewController = catFactViewController
        initialWindow.makeKeyAndVisible()
        
        window = initialWindow
    }
}
