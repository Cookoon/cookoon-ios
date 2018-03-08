//
//  AppDelegate.swift
//  cookoon-ios
//
//  Created by Charles PERNET on 14/09/2017.
//  Copyright © 2017 Charles PERNET. All rights reserved.
//

import UIKit
import Turbolinks

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()
    var session = Session()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MSAppCenter.start(Bundle.main.object(forInfoDictionaryKey: "APP_CENTER_SECRET") as! String, withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ])

        // Override point for customization after application launch.
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        session.delegate = self

        Branch.getInstance().initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            let url: String

            if error == nil && params!["+clicked_branch_link"] != nil && params!["$deeplink_path"] != nil {
                url = params!["$deeplink_path"] as! String
            } else if error == nil && params!["+clicked_branch_link"] != nil && params!["+non_branch_link"] != nil {
                url = params!["+non_branch_link"] as! String
            } else {
                url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
            }

            self.visit(url: URL(string: url)!)
        })

        return true
    }

    func visit(url: URL) {
        let viewController = VisitableViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)
        session.visit(viewController)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }
}

extension AppDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisitToURL URL: URL, withAction action: Action) {
        visit(url: URL)
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        //        TODO:
    }
}
