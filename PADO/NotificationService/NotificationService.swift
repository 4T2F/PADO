//
//  NotificationService.swift
//  NotificationService
//
//  Created by 최동호 on 2/5/24.
//

import FirebaseMessaging
import Foundation
import SwiftUI

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            if let apsData = request.content.userInfo["aps"] as? [String: Any],
               let alertData = apsData["alert"] as? [String: Any],
               let imageData = request.content.userInfo["fcm_options"] as? [String: Any] {
                
                bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
                bestAttemptContent.body = "\(bestAttemptContent.body) [modified]"
                
                if let urlImageString = imageData["image"] as? String,
                   let newsImageUrl = URL(string: urlImageString) {
                    
                    do {
                        let imageData = try Data(contentsOf: newsImageUrl)
                        if let attachment = UNNotificationAttachment.saveImageToDisk(identifier: "newsImage.jpg", data: imageData, options: nil) {
                            bestAttemptContent.attachments = [attachment]
                        }
                    } catch {
                        print("Error loading image data: \(error)")
                    }
                }
                
                // Messaging.serviceExtension() 호출은 예제에 따라 필요에 맞게 조정해야 합니다.
                // Messaging.serviceExtension().populateNotificationContent(bestAttemptContent, withContentHandler: self.contentHandler!)
                
                contentHandler(bestAttemptContent)
            } else {
                contentHandler(bestAttemptContent) // userInfo에 필요한 데이터가 없는 경우
            }
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

extension UNNotificationAttachment {
    static func saveImageToDisk(identifier: String, data: Data, options: [AnyHashable : Any]? = nil) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)!
        
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL.appendingPathExtension(identifier)
            try data.write(to: fileURL)
            let attachment = try UNNotificationAttachment(identifier: identifier, url: fileURL, options: options)
            return attachment
        } catch {
            print("saveImageToDisk error - \(error)")
        }
        return nil
    }
}
