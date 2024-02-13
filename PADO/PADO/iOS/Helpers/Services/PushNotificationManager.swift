//
//  PushNotificationManager.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import Foundation

final class PushNotificationManager {
    // Singleton 인스턴스
    static let shared = PushNotificationManager()
    
    private init() { }
    
    // FCM 푸시 알림을 보내는 함수
    func sendPushNotification(toFCMToken token: String?, title: String, body: String, categoryIdentifier: String) {
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
                "sound": "default",
                "click_action": categoryIdentifier
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
    
    func sendPushNotificationWithImage(toFCMToken token: String?, title: String, body: String, imageUrl: String) {
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
                "badge": "1",
                "sound": "default"
            ],
            "mutable-content": 1, // 알림이 수정 가능함을 나타냄
            "fcm_options": ["image": imageUrl] // 이미지 URL을 포함
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
