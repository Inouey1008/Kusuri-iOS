//
//  AppDelegate.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/08.
//

import UIKit
import Siren
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("Application will finish launching")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Application did finish launching")
        setupVersionUpdateNotification()
        setupNavigationBar()
        setupTabBar()
        setupWindow()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application did become active")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("Application will resign active")
    }

    func applicationWillEnterForeground(_: UIApplication) {
        print("Application will enter foreground")
    }

    func applicationDidEnterBackground(_: UIApplication) {
        print("Application did enter background")
    }

    func applicationWillTerminate(_: UIApplication) {
        print("Application will terminate")
    }

    func applicationDidFinishLaunching(_: UIApplication) {
        print("Application did finish launching")
    }

    func applicationDidReceiveMemoryWarning(_: UIApplication) {
        print("Applicationd did receive memory warning")
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().backgroundColor = .primary
        UINavigationBar.appearance().barTintColor = .primary
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .backgroundCover
        UINavigationBar.appearance().tintColor = .primary
    }
    
    private func setupTabBar() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .backgroundBase
        UITabBar.appearance().tintColor = .primary
        UITabBar.appearance().unselectedItemTintColor = .gray
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabRouter.generate()
        window?.makeKeyAndVisible()
    }
    
    private func setupVersionUpdateNotification() {
        Siren.shared.rulesManager = RulesManager(
            majorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force),
            minorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .option),
            patchUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .skip)
        )
        Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .japanese)
        Siren.shared.apiManager = APIManager(country: .japan)
        Siren.shared.wail()
    }
}
