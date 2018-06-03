//
//  AppDelegate.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 14/12/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set up the style and color of the common UI elements
        customizeUIStyle()
        
        // 會讀取GoogleService-Info.plist，一開啟就連接Firebase
        FirebaseApp.configure()
        
        // 作為從Facebook登入傳遞處理結果(例如切換至原生FB App 或 傳遞FB對話框)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // 初始化 Google SignIn 的用戶端ID
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        
        return true
    }
    // 當FB切回原本的app 這個open options方法會被調用，所以必須實作這個方法處理FB登入
    // 要能正確的處理登入，他需要由FB呼叫FBSDKApplicationDelegate的application方法
    // 這邊是處理從FB or Google url的驗證，若是正確則回傳true，再來跑到使用者帳號登入驗證
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled = false
        
        if url.absoluteString.contains("fb") {
            handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        }else{
            // 呼叫Google SignIn實例的handle方法處理app最後驗證程序所接收的url
            handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }
        return handled
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


}


extension AppDelegate {
    func customizeUIStyle() {
        
        // Customize Navigation bar items
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Avenir", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.normal)
    }
}
