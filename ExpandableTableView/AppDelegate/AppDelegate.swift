//
//  AppDelegate.swift
//  ExpandableTableView
//
//  Created by Lucas Nascimento on 19/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let viewController = ExpandableTableViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window.backgroundColor = UIColor.white
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
    }
}

