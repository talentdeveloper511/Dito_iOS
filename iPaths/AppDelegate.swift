//
//  AppDelegate.swift
//  iPaths
//
//  Created by ApporioMac8 on 03/04/17.
//  Copyright © 2017 Marko Dreher. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
//import FacebookLogin
//import FacebookCore
import CoreData
//import FBSDKShareKit
//import FBSDKLoginKit
import IQKeyboardManagerSwift
import UserNotifications
import Stripe
import Firebase

import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate{

    
    var receivedPushChannelUrl: String?
var senddeviceid = ""
    var window: UIWindow?
    static let instance: NSCache<AnyObject, AnyObject> = NSCache()

    static func imageCache() -> NSCache<AnyObject, AnyObject>! {
        if AppDelegate.instance.totalCostLimit == 104857600 {
            AppDelegate.instance.totalCostLimit = 104857600
        }
        
        return AppDelegate.instance
    }
var locationManager = CLLocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs
//        FirebaseApp.configure()
        
       STPPaymentConfiguration.shared().publishableKey = "pk_test_tmwp3hom31vRt1nGhfxDFaJH"
        IQKeyboardManager.shared.enable = true
                GMSServices.provideAPIKey(Constants.GOOGLE_PLACESDK_API)
                GMSPlacesClient.provideAPIKey(Constants.GOOGLE_PLACESDK_API )

        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        window?.tintColor = UIColor(red:0.31, green:0.08, blue:0.55, alpha:1.0)
        application.applicationIconBadgeNumber = 0
        
        SBDMain.initWithApplicationId("B1827938-0F36-4988-BB9B-DEA33ABCF49D")
        SBDMain.setLogLevel(SBDLogLevel.none)
        SBDOptions.setUseMemberAsMessageSender(true)
        
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
//        }
//        catch {
//
//        }
//
//
//        ConnectionManager.login { (user, error) in
//            guard error == nil else {
//                let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//                let viewController: UIViewController? = storyboard.instantiateInitialViewController()
//                self.window?.rootViewController = viewController
//                self.window?.makeKeyAndVisible()
//                return;
//            }
//
//            self.window?.rootViewController = MenuViewController()
//            self.window?.makeKeyAndVisible()
//        }
//
        
        
        return true

        // Override point for customization after application launch.
        //return true
    }
    // Called when APNs has assigned the device a unique token
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//    }
//
    // Called when APNs failed to register the device for push notifications
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        // Print the error to console (you should alert the user that registration failed)
//        print("APNs registration failed: \(error)")
//    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            #if !(arch(i386) || arch(x86_64))
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) -> Void  in
                        guard settings.authorizationStatus == UNAuthorizationStatus.authorized else {
                            return;
                        }
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    })
                }
            }
            #endif
        } else {
            #if !(arch(i386) || arch(x86_64))
            let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
            #endif
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
//        AppEventsLogger.activate(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
     
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SBDMain.registerDevicePushToken(deviceToken, unique: true) { (status, error) in
            if error == nil {
                if status == SBDPushTokenRegistrationStatus.pending {
                    
                }
                else {
                    
                }
            }
            else {
                
            }
        }
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if userInfo["sendbird"] != nil {
            let sendBirdPayload = userInfo["sendbird"] as! Dictionary<String, Any>
            let channel = (sendBirdPayload["channel"]  as! Dictionary<String, Any>)["channel_url"] as! String
            let channelType = sendBirdPayload["channel_type"] as! String
            if channelType == "group_messaging" {
                self.receivedPushChannelUrl = channel
            }
        }
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("method for handling events for background url session is waiting to be process. background session id: \(identifier)")
        completionHandler()
    }
    

  }


