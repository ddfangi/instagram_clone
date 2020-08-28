//
//  AppDelegate.swift
//  InstagramFB
//
//  Created by David on 25/09/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//
//        var isUniversalLinkClick: Bool = false
//        if let launchOptions = launchOptions, let activityDictionary = launchOptions[UIApplicationLaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
//            if let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity {
//                    isUniversalLinkClick = true
//            }
//        }
//
//        if isUniversalLinkClick {
//            // app opened via clicking a universal link.
//        } else {
//            // set the initial viewcontroller
//        }
//        return true
//
    
        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()

        attemptRegisterForeNotifications(application: application)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications: \(deviceToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token: \(fcmToken)")
    }
    
    // listen for user notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    private func attemptRegisterForeNotifications(application: UIApplication) {
        print("Attempting to register for APNS ...")
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // user notificaiton auth
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                print("Failed to request auth: \(error)")
                return
            }
            
            if granted {
                print("Auth granted ...")
            } else {
                print("Auth denied ...")
            }
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            print(queryParameters(from: url))
            //handle url and open whatever page you want to open.
        }
        return true
    }

    func queryParameters(from url: URL) -> [String: String] {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParams = [String: String]()
        for queryItem: URLQueryItem in (urlComponents?.queryItems)! {
            if queryItem.value == nil {
                continue
            }
            queryParams[queryItem.name] = queryItem.value
        }
        return queryParams
    }
}

