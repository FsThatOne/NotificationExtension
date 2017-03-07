//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by 王正一 on 2017/2/28.
//  Copyright © 2017年 FsThatOne. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    fileprivate var messageImageView: UIImageView?
    
    fileprivate var imageView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        switch notification.request.content.categoryIdentifier {
        case "imageView":
            preferredContentSize = CGSize(width: view.bounds.width, height: 230)
            imageView = UIView(frame: view.bounds)
            let path = Bundle.main.path(forResource: "wwdc17", ofType: "jpg")
            let imageViewa = UIImageView(image: UIImage(contentsOfFile: path!))
            imageViewa.frame = CGRect(x: 5, y: 5, width: view.bounds.width, height: 220)
            imageView!.addSubview(imageViewa)
            view.addSubview(imageView!)
            break
        case "messageView":
            preferredContentSize = CGSize(width: view.bounds.width , height: 700)
            let path = Bundle.main.path(forResource: "message", ofType: "png")
            messageImageView = UIImageView(image: UIImage(contentsOfFile: path!))
            messageImageView!.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 700)
            view.addSubview(messageImageView!)
            break
        case "approvalView":
            preferredContentSize = CGSize(width: view.bounds.width , height: 600)
            let path = Bundle.main.path(forResource: "approval", ofType: "png")
            messageImageView = UIImageView(image: UIImage(contentsOfFile: path!))
            messageImageView!.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 600)
            view.addSubview(messageImageView!)
            break;
        case "approvalDetailView":
            preferredContentSize = CGSize(width: view.bounds.width , height: 700)
            let path = Bundle.main.path(forResource: "approvalDetail", ofType: "png")
            messageImageView = UIImageView(image: UIImage(contentsOfFile: path!))
            messageImageView!.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 700)
            view.addSubview(messageImageView!)
            break
        default:
            preferredContentSize = CGSize(width: view.bounds.width, height: 500)
            let imageView = UIImageView(frame: view.bounds)
            view.addSubview(imageView)
            break
        }
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        let notify = response.notification
        let categoryId = notify.request.content.categoryIdentifier
        switch categoryId {
        case "imageView":
            completion(.dismissAndForwardAction)
            break
        case "messageView":
            if response.actionIdentifier == "detail" {
                completion(.dismissAndForwardAction)
            } else {
                let path = Bundle.main.path(forResource: "messageRe", ofType: "png")
                messageImageView?.image = UIImage(contentsOfFile: path!)
                completion(.doNotDismiss)
            }
            break
        case "approvalView":
            view.resignFirstResponder()
            completion(.dismiss)
            break
        case "approvalDetailView":
            view.resignFirstResponder()
            completion(.dismissAndForwardAction)
            break
        default:
            if response.actionIdentifier == "textFiled" {
                completion(.doNotDismiss)
            } else if response.actionIdentifier == "transfer" {
                completion(.dismissAndForwardAction)
            } else {
                completion(.dismiss)
            }
            break
        }
        
    }
//    
//    var mediaPlayPauseButtonFrame: CGRect {
//        return CGRect(x: 0, y: 0, width: 100, height: 100)
//    }

    
    // 没有播放按钮
    // UNNotificationContentExtensionMediaPlayPauseButtonTypeNone,
    // 有播放按钮，点击播放之后，按钮依旧存在，类似音乐播放的开关
    // UNNotificationContentExtensionMediaPlayPauseButtonTypeDefault,
    // 有播放按钮，点击后，播放按钮消失，再次点击暂停播放后，按钮恢复
    // UNNotificationContentExtensionMediaPlayPauseButtonTypeOverlay,
//    var mediaPlayPauseButtonType: UNNotificationContentExtensionMediaPlayPauseButtonType {
//        let type:  UNNotificationContentExtensionMediaPlayPauseButtonType = .default
//            return type
//    }
    
}

extension NotificationViewController {
    func mediaPlay() {
        // 音视频开始播放时,会调用此方法
    }
    
    func mediaPause() {
        // 音视频暂停时会调用此方法
    }
}
