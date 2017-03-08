//
//  ViewController.swift
//  NotificationExtension
//
//  Created by 王正一 on 2017/2/28.
//  Copyright © 2017年 FsThatOne. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import MobileCoreServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testRemoveDeliverdNotice()
        testAll()
        testInAppApproval()
        testInAppApprovalDetail()
    }
    
    // 本地通知基础
    func testBasicNotice() {
        /// content
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "你收到了一条消息"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.userInfo = ["name": "美办"]
        
        /// 触发器
        // 日期触发器
        var dateComponents = DateComponents()
        dateComponents.weekday = 4 // 周三触发
        dateComponents.hour = 12 // 12点
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 延时触发器
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        // 位置触发器
        let cen = CLLocationCoordinate2D(latitude: 39.990465, longitude: 116.333386)
        let region = CLCircularRegion(center: cen, radius: 1000, identifier: "center")
        region.notifyOnEntry = true;
        region.notifyOnExit = false;
        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        /// request
        let timeRequest = UNNotificationRequest(identifier: "meiban", content: notify, trigger: timeTrigger)
        let calendarRequest = UNNotificationRequest(identifier: "meiban1", content: notify, trigger: dateTrigger)
        let locationRequest = UNNotificationRequest(identifier: "meiban2", content: notify, trigger: locationTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
        UNUserNotificationCenter.current().add(calendarRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
        UNUserNotificationCenter.current().add(locationRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    // 更新通知
    func testUpdateNotice() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "你收到了一条消息"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.userInfo = ["name": "美办"]
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "meiban", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
        
        sleep(4)
        
        let notify1 = UNMutableNotificationContent()
        notify1.title = "美办"
        notify1.subtitle = "云办公事业部"
        notify1.body = "你又又又又又收到了一条消息"
        notify1.badge = 2
        notify1.sound = UNNotificationSound.default()
        notify1.userInfo = ["name": "美办"]
        
        let timeTrigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest1 = UNNotificationRequest(identifier: "meiban", content: notify1, trigger: timeTrigger1)
        UNUserNotificationCenter.current().add(timeRequest1) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    // 删除通知
    func testRemoveDeliverdNotice() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:[图片]"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.userInfo = ["name": "美办"]
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "meiban", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
        
        sleep(6)
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["meiban"])
    }
    // 通知附件
    func testAttachment() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:[图片]"
        notify.badge = 1
//        notify.sound = UNNotificationSound.default()
        notify.userInfo = ["name": "美办"]
        
        // 图片附件
        let path = Bundle.main.path(forResource: "wwdc17", ofType: "jpg")
        let url = URL(fileURLWithPath: path!)
        let attach = try! UNNotificationAttachment(identifier: "", url: url, options: [
//            UNNotificationAttachmentOptionsTypeHintKey: kUTTypeImage, // 提示附件类型
//            UNNotificationAttachmentOptionsThumbnailHiddenKey: false, // 通知放大后是否隐藏原有通知,default = true,隐藏
//            UNNotificationAttachmentOptionsThumbnailTimeKey: 3, // 用于类型的附件,可以设置某个时间的一帧作为缩略图
            UNNotificationAttachmentOptionsThumbnailClippingRectKey: CGRect(dictionaryRepresentation: CGRect(x: 0.5, y: 0.5, width: 0.25, height: 0.25).dictionaryRepresentation)!
            // 这个需要特别讲解一下,详见PPT
            ])
        notify.attachments = [attach]
        notify.launchImageName = "wwdc17.jpg"
        
        // 通知铃声
        let noticeSound = UNNotificationSound(named: "unbelievable.caf")  // 铃声支持的格式有caf,wav,aiff
        // terminal中可以敲"afconvert unbelievable.mp3 unbelievable.caf -d ima4 -f caff -v"命令使用afconvert工具来转化
        notify.sound = noticeSound
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "meiban", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    // 通知按声音分类
    func testSortNoticeBySound() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:[图片]"
        notify.badge = 1
        notify.userInfo = ["name": "美办"]
        notify.sound = UNNotificationSound(named: "unbelievable.caf")
        let path = Bundle.main.path(forResource: "pp", ofType: "jpeg")
        let url = URL(fileURLWithPath: path!)
        let attach = try! UNNotificationAttachment(identifier: "", url: url, options: nil)
        notify.attachments = [attach]
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "meibanAll", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
        let notify1 = UNMutableNotificationContent()
        notify1.title = "美办"
        notify1.subtitle = "云办公iOS组"
        notify1.body = "孔涛: 大家把周报提交一下."
        notify1.badge = 2
        notify1.userInfo = ["name": "美办"]
        notify1.sound = UNNotificationSound(named: "electric.caf")
        
        let timeTrigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let timeRequest1 = UNNotificationRequest(identifier: "meibaniOS", content: notify1, trigger: timeTrigger1)
        UNUserNotificationCenter.current().add(timeRequest1) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    
    /// content
    // NotificationContent
    func testSortContent() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:[图片]"
        notify.badge = 1
        notify.userInfo = ["name": "美办"]
        notify.sound = UNNotificationSound(named: "unbelievable.caf")
        notify.categoryIdentifier = "imageView"
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "meibanAll", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    
    // 测试音频文件
    func testVideo() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:[视频] 足球哈哈哈"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.userInfo = ["name": "美办"]
        notify.categoryIdentifier = "videoView"
        
        let path = Bundle.main.path(forResource: "testMv", ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        let attach = try! UNNotificationAttachment(identifier: "", url: url, options: [
            UNNotificationAttachmentOptionsThumbnailTimeKey: 3, // 用于类型的附件,可以设置某个时间的一帧作为缩略图
        ])
        notify.attachments = [attach]
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "video", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    // 聊天通知
    func testMessageView() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:we"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.categoryIdentifier = "messageView"

        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "message", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }

    }
    
    // 测试imageView
    func testImageView() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.subtitle = "云办公事业部"
        notify.body = "曹烨:[图片]"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.userInfo = ["name": "美办"]
        
        // 图片附件
        let path = Bundle.main.path(forResource: "wwdc17", ofType: "jpg")
        let url = URL(fileURLWithPath: path!)
        let attach = try! UNNotificationAttachment(identifier: "", url: url, options: nil)
        notify.attachments = [attach]
        notify.launchImageName = "wwdc17.jpg"
        notify.categoryIdentifier = "imageView"
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "image", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    
    // 测试审批
    func testApproval() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.body = "您有一项待审批的任务"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.categoryIdentifier = "approvalView"
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "approval", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    
    // 测试审批
    func testApprovalDetail() {
        let notify = UNMutableNotificationContent()
        notify.title = "美办"
        notify.body = "您有一项已完成审批的任务"
        notify.badge = 1
        notify.sound = UNNotificationSound.default()
        notify.categoryIdentifier = "approvalDetailView"
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "approvalDetail", content: notify, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(timeRequest) { (error) in
            if (error != nil) {
                print("错误:\(error)")
            }
        }
    }
    
    func testAll() {
        testVideo()
        testApproval()
        testMessageView()
        testImageView()
        testApprovalDetail()
    }

    func testInAppApproval() {
        testApproval()
    }
    
    func testInAppApprovalDetail() {
        testApprovalDetail()
    }
}

