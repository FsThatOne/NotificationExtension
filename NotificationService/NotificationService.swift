//
//  NotificationService.swift
//  NotificationService
//
//  Created by 王正一 on 2017/3/2.
//  Copyright © 2017年 FsThatOne. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [修改后的标题]" + "哈哈哈"
            bestAttemptContent.subtitle = "\(bestAttemptContent.subtitle) [修改后的子标题]" + "哈哈哈"
            
            //1. 下载
            let url = URL(string: "http://img1.gtimg.com/sports/pics/hv1/194/44/2136/138904814.jpg")
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "download/image.jpg"
            let task: URLSessionDataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    let image = UIImage(data: data!)
                    // 2. 存起来
                    try! UIImageJPEGRepresentation(image!, 1)!.write(to: URL(string: path)!, options: .atomic)
                }
                // 3. 生成附件
                if let attach = try? UNNotificationAttachment(identifier: "remote", url: URL(string: path)!, options: nil) {
                    // 4. 设置附件
                    bestAttemptContent.attachments = [attach]
                    contentHandler(bestAttemptContent)
                }
            })
            task.resume()
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
