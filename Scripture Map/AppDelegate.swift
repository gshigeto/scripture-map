//
//  AppDelegate.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 10/30/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    // MARK: - Storyboard
    private struct Storyboard {
        static let DetailViewControllerRestorationIdentifier = "DetailVC"
    }

    // MARK: - Properties
    var window: UIWindow?

    // MARK: - Application Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let splitViewController = window!.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
        }
        return true
    }

    // MARK: - Split View
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
 
    func splitViewController(_ splitViewController: UISplitViewController,
                             separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        if let navVC = primaryViewController as? UINavigationController {
            for controller in navVC.viewControllers {
                if controller.restorationIdentifier == Storyboard.DetailViewControllerRestorationIdentifier {
                    return controller
                }
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Storyboard.DetailViewControllerRestorationIdentifier)
    }
}

