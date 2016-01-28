//
//  AppDelegate.swift
//  GitterViewer
//
//  Created by Jeffrey Kereakoglow on 1/28/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder {
  var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


    //-- Persistence
    let store = Store(modelName: "GitterViewer")
    let stack = PersistentStack(modelURL: store.modelURL, storeURL: store.storeURL)

    return true
  }

}