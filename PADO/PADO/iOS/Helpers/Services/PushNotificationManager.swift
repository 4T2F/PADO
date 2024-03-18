//
//  PushNotificationManager.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import Foundation

final class PushNotificationManager {
    static let shared = PushNotificationManager()
    
    private init() { }
    private let serverKey: String = Bundle.main.object(forInfoDictionaryKey: "firebase_Push_Api_Key") as? String ?? ""
    // FCM 푸시 알림을 보내는 함수
    func sendPushNotification(toFCMToken token: String?, 
                              title: String,
                              body: String,
                              categoryIdentifier: String,
                              user: User) {
        
        guard let token else {
            print("⚠️ FCM 토큰이 비어있습니다.")
            return
        }
        
        let message: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body,
                "badge": 0,
                "sound": "default",
                "click_action": categoryIdentifier,
                "content_available" : true,
                "mutable_content": true
            ],
            "data": [
                "User_id": user.id ?? "",
                "User_profileImageUrl": user.profileImageUrl ?? "",
            ]
        ]
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            request.httpBody = data
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending FCM message: \(error.localizedDescription)")
            } else if let data = data {
                let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("FCM response: \(response ?? [:])")
            }
        }
        task.resume()
    }
    
    func sendPushNotificationWithPost(toFCMToken token: String?, 
                                      title: String,
                                      body: String,
                                      categoryIdentifier: String,
                                      post: Post
    ) {
        guard let token = token else {
            print("⚠️ FCM 토큰이 비어있습니다.")
            return
        }
        
        let message: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body,
                "badge": 0,
                "sound": "default",
                "click_action": categoryIdentifier,
                "content_available" : true,
                "mutable_content": true
            ],
            "data": [
                "Post_id": post.id ?? "",
                "Post_imageUrl": post.imageUrl,
            ]
        ]
        
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            request.httpBody = data
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending FCM message: \(error.localizedDescription)")
            } else if let data = data {
                let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("FCM response: \(response ?? [:])")
            }
        }
        task.resume()
    }
    
    func sendPostitPushNotification(toFCMToken token: String?,
                                    title: String,
                                    body: String,
                                    categoryIdentifier: String,
                                    userID: String,
                                    userUrl: String
    ) {
        let serverKey: String = Bundle.main.object(forInfoDictionaryKey: "firebase_Push_Api_Key") as? String ?? "1"
        
        guard let token else {
            print("⚠️ FCM 토큰이 비어있습니다.")
            return
        }
        
        let message: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body,
                "badge": 0,
                "sound": "default",
                "click_action": categoryIdentifier,
                "content_available" : true,
                "mutable_content": true
            ],
            "data": [
                "User_id": userID,
                "User_profileImageUrl": userUrl,
            ]
        ]
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            request.httpBody = data
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending FCM message: \(error.localizedDescription)")
            } else if let data = data {
                let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("FCM response: \(response ?? [:])")
            }
        }
        task.resume()
    }
}
