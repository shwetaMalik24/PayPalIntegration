//
//  AppDelegate.swift
//  PaymentGWIntegration
//
//  Created by Drish on 20/07/20.
//  Copyright © 2020 Drish. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "ATI0A-JqajZJtsrxxQRcKcVNM2e8Whyb8j3zvuZr4ubeCmERbkXf4ii177WcjLskBQTGUhIugsQxdG0G", PayPalEnvironmentSandbox: "AQR2TqLPquhukDYqwcZ3doQS943Pr9k6o-oGU5y4EzlDa4Z9eXEhAR-zEx96Sr25Hw8Iao1m6tyhTrR8"])
              return true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

