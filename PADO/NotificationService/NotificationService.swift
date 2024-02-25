//
//  NotificationService.swift
//  NotificationService
//
//  Created by 최동호 on 2/5/24.
//

import SwiftUI
import Intents
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    // APNs를 수신하면 didReceive 메소드 호출
    // contentHnadler 클로저를 수행하면 푸시가 노출
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // attachment에 이미지 넣기: https://ios-development.tistory.com/1282
        setAttachment(request: request, contentHandler: contentHandler)
        
        // 푸시 app icon 부분 커스텀 하기: https://ios-development.tistory.com/1283
        setAppIconToCustom(request: request, contentHandler: contentHandler)
    }
    
    private func setAttachment(request: UNNotificationRequest, 
                               contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        guard let bestAttemptContent else { return }
        bestAttemptContent.title = "변경 " + request.content.title
        bestAttemptContent.subtitle = "변경 " + request.content.subtitle
        
        // 푸시에 이미지 추가
        let imageURLString = request.content.userInfo["image"] as! String
        do {
            // 이미지 타입으로 저장하지 않으면 error나므로 주의 (.png, .jpg 등으로 할 것)
            try saveFile(id: "myImage.png", 
                         imageURLString: imageURLString) { fileURL in
                do {
                    print(fileURL.absoluteURL)
                    let attachment = try UNNotificationAttachment(identifier: "", url: fileURL, options: nil)
                    bestAttemptContent.attachments = [attachment]
                    contentHandler(bestAttemptContent)
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func setAppIconToCustom(request: UNNotificationRequest, 
                                    contentHandler: @escaping (UNNotificationContent) -> Void) {
        // Intent를 사용 전에는 info.plist에 키-값 추가 필요
        // NSUserActivityTypes을 array로 놓고 배열 중 하나의 값으로 INSendMessageIntent 입력

        let avatar = INImage(imageData: UIImage(named: "my_image.png")!.pngData()!)
        
        let senderPerson = INPerson(
            personHandle: INPersonHandle(value: "unique-sender-id-2", type: .unknown),
            nameComponents: nil,
            displayName: "Sender name",
            image: avatar,
            contactIdentifier: nil,
            customIdentifier: nil,
            isMe: false,
            suggestionType: .none
        )
        
        let mePerson = INPerson(
            personHandle: INPersonHandle(value: "unique-me-id-2", type: .unknown),
            nameComponents: nil,
            displayName: nil,
            image: nil,
            contactIdentifier: nil,
            customIdentifier: nil,
            isMe: true,
            suggestionType: .none
        )
        
        // Intent
        let intent = INSendMessageIntent(recipients: [mePerson],
                                         outgoingMessageType: .outgoingMessageText,
                                         content: "Message content",
                                         speakableGroupName: nil,
                                         conversationIdentifier: "unique-conversation-id-1",
                                         serviceName: nil,
                                         sender: senderPerson,
                                         attachments: nil)
        
        //
        intent.setImage(avatar, forParameterNamed: \.sender)
//        intent.setImage(avatar, forParameterNamed: \.speakableGroupName) // 그룹
        
        // interaction
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming
        
        // 알림을 주기 전에 `donate`
        interaction.donate { error in
            if let error = error {
                print(error)
                return
            }
            
            do {
                // 이전 notification에 intent를 더해주고, 노티 띄우기
                let updatedContent = try request.content.updating(from: intent)
                contentHandler(updatedContent)
            } catch {
                print(error)
            }
        }
    }
    
    // didReceive에서 contentHandler가 호출되지 않고 특정 시간이 경과하면 이 메소드가 호출
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func saveFile(id: String, imageURLString: String, completion: (_ fileURL: URL) -> Void) throws {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(id)
        
        guard
            let imageURL = URL(string: imageURLString),
            let data = try? Data(contentsOf: imageURL)
        else { throw URLError(.cannotDecodeContentData) }
        try data.write(to: fileURL)
        completion(fileURL)
    }
}
