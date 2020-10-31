//
//  AppDelegate.swift
//  WisHope
//
//  Created by Kyle Cain on 2/16/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

public var sortedString : String?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate  {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UNUserNotificationCenter.current().delegate = self
        
        print(Messaging.messaging().fcmToken ?? "")
        print("\n\n\n\n\n\n\n")
        User.fcm = Messaging.messaging().fcmToken ?? ""

        return true
    }


    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            //print("Firebase registration token: \(fcmToken)")
    
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            // TODO: If necessary send token to application server.
            // Note: This callback is fired at each app startup and whenever a new token is generated.
        }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //print("Token : \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        print(response.notification.request.content)
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
    
        guard let ruid = userInfo["receiver"] as? String else {
            return print("notification did not contain body 'app'")
        }
        guard let cuid = userInfo["caller"] as? String else {
            return print("notification did not contain body 'app'")
        }
        let nonSortedString = ruid + cuid
        let sortedString = String(nonSortedString.sorted())
        
        switch application.applicationState {
        case .active:
            print("user tapped notification when in the app")
        case .inactive:
            print("user tapped notification when out of the app")
        default:
            print("something went wrong with detecting application being active or inactive")
        }

        print(sortedString)
        
        openRoom(sortedString)
        
        
        //this is what will need to be changed with FCM integration
        //print(userInfo["app"])

    completionHandler()
    }
    
    
    func openRoom(_ roomString: String) {
        print("openroom called")
        if let rootController = UIStoryboard(name: "Communication", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommunicationVC") as? CommunicationViewController {
            
            print("opening vc")
            rootController.roomString = roomString
            self.window?.rootViewController = rootController
            //print(self.window?.rootViewController!)
            self.window?.makeKeyAndVisible()
        }
    }
    
    //MARK:- HERE
    
    /// this works, but a better solution is needed
    /// - Parameter application: app force quit
    func applicationWillTerminate(_ application: UIApplication){
        updateUserStatus(uid: User.uid, online: false)
        sleep(10)
    }
    


}

