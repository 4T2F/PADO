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
    func sendPushNotification(toFCMToken token: String?, title: String, body: String, categoryIdentifier: String, user: User) {
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
                "User_id": user.id ?? "",
                "User_username": user.username,
                "User_lowercasedName": user.lowercasedName,
                "User_nameID": user.nameID,
                "User_profileImageUrl": user.profileImageUrl ?? "",
                "User_backProfileImageUrl": user.backProfileImageUrl ?? "",
                "User_date": user.date,
                "User_bio": user.bio ?? "",
                "User_location": user.location ?? "",
                "User_phoneNumber": user.phoneNumber,
                "User_fcmToken": user.fcmToken,
                "User_alertAccept": user.alertAccept,
                "User_instaAddress": user.instaAddress,
                "User_tiktokAddress": user.tiktokAddress
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
    
    func sendPushNotificationWithPost(toFCMToken token: String?, title: String, body: String, categoryIdentifier: String, post: Post) {
        let serverKey: String = Bundle.main.object(forInfoDictionaryKey: "firebase_Push_Api_Key") as? String ?? "1"
        
        guard let token = token else {
            print("⚠️ FCM 토큰이 비어있습니다.")
            return
        }
        
        var message: [String: Any] = [:]
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // DateFormatter 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜/시간 형식 지정
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // 필요한 경우 타임존 설정
        
        encoder.dateEncodingStrategy = .formatted(dateFormatter) // encoder에 날짜 형식 지정
        
        let createdDateString = dateFormatter.string(from: post.created_Time.dateValue())
        let modifiedDateString = post.modified_Time.map { dateFormatter.string(from: $0.dateValue()) } ?? "N/A"
        
        message = [
            "to": token,
            "notification": [
                "title": title,
                "body": body,
                "badge": 0,
                "sound": "Tri_tone",
                "click_action": categoryIdentifier,
                "content_available" : true,
                "mutable_content": true
            ],
            "data": [
                "Post_id": post.id ?? "",
                "Post_ownerUid": post.ownerUid,
                "Post_surferUid": post.surferUid,
                "Post_imageUrl": post.imageUrl,
                "Post_title": post.title,
                "Post_heartsCount": post.heartsCount,
                "Post_commentCount": post.commentCount,
                "Post_hearts": "",
                "Post_comments": "",
                "Post_created_Time": createdDateString,
                "Post_modified_Time": modifiedDateString
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
}
