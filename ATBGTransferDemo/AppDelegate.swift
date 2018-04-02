//
//  AppDelegate.swift
//  ATBGTransferDemo
//
//  Created by Dejan on 01/04/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var bgSessionCompletionHandler: (() -> Void)?
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgSessionCompletionHandler = completionHandler
    }
}

