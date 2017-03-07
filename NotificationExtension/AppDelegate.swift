//
//  AppDelegate.swift
//  NotificationExtension
//
//  Created by 王正一 on 2017/2/28.
//  Copyright © 2017年 FsThatOne. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            setupCategories()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (bool, error) in
                if bool {
                    // 注册成功
                    center.getNotificationSettings(completionHandler: { (setting) in
                        print(setting)
                    })
                } else {
                    // 注册失败
                }
            }
        }else {
            let setting = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            application.registerUserNotificationSettings(setting)
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    // 弹通知之前的操作 只有在应用在前台时会调用
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            print("远程推送")
            completionHandler([.badge, .alert, .sound])
        } else {
            print("本地推送")
            if notification.request.content.categoryIdentifier == "approvalView" || notification.request.content.categoryIdentifier == "approvalDetailView" {
                completionHandler([.badge, .alert, .sound])
            }
        }
    }
    
    // 点开通知或者点击通知的Action会调用
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            print("远程推送")
            completionHandler()
        } else {
            print("本地推送")
            
            completionHandler()
        }
    }
}

extension AppDelegate {
    func setupCategories() {
        let transforAction = UNNotificationAction(identifier: "transfor", title: "转发", options: [.foreground])
        let agreeAction = UNTextInputNotificationAction(identifier: "agree", title: "同意", options: [.foreground], textInputButtonTitle: "同意", textInputPlaceholder: "同意理由")
        let refuseAction = UNTextInputNotificationAction(identifier: "refuse", title: "拒绝", options: [.foreground, .destructive], textInputButtonTitle: "拒绝", textInputPlaceholder: "拒绝理由")
        let collectAction = UNNotificationAction(identifier: "collect", title: "收藏", options: [.foreground])
        let detailAction = UNNotificationAction(identifier: "detail", title: "查看详情", options: [.foreground])
        let saveAction = UNNotificationAction(identifier: "save", title: "保存附件", options: [.foreground])
        let saveToAction = UNNotificationAction(identifier: "saveTo", title: "归档", options: [.foreground, .destructive])
        let actionTextField = UNTextInputNotificationAction(identifier: "textFiled", title: "回复", options: [.foreground], textInputButtonTitle: "发送", textInputPlaceholder: "回复曹烨")
        let imageCat = UNNotificationCategory(identifier: "imageView", actions: [actionTextField, detailAction, saveAction], intentIdentifiers: ["actionTextField", "detailAction", "SaveAction"], options: [])
        let messageCat = UNNotificationCategory(identifier: "messageView", actions: [actionTextField, detailAction], intentIdentifiers: ["actionTextField", "detailAction"], options: [])
        let videoCat = UNNotificationCategory(identifier: "videoView", actions: [actionTextField, transforAction, collectAction], intentIdentifiers: ["actionTextField", "transforAction", "collectAction"], options: [])
        let approvalCat = UNNotificationCategory(identifier: "approvalView", actions: [agreeAction, refuseAction], intentIdentifiers: ["actionTextField", "detailAction"], options: [])
        let approvalDetailCat = UNNotificationCategory(identifier: "approvalDetailView", actions: [detailAction, saveToAction], intentIdentifiers: ["detailAction", "saveToAction"], options: [])

        let set: Set<UNNotificationCategory> = [imageCat, messageCat, videoCat, approvalCat, approvalDetailCat]
        UNUserNotificationCenter.current().setNotificationCategories(set)
    }
}
