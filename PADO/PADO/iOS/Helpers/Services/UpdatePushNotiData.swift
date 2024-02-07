//
//  UpdatePushNotiData.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

enum PostNotiType {
    case comment
    case facemoji
    case heart
    
}
enum NotiType {
    case follow
    case surfer
    case requestSurfing
}

class UpdatePushNotiData {
    let db = Firestore.firestore()
    //포스트의 정보가 포함된 경우 알람(하위컬렉션 이름을 포스트이름으로 하기 위함)
    func pushPostNoti(targetPostID: String, receiveUser: User, type: PostNotiType, message: String) async { // 이미지도 포함하게 될 푸시 알람들
        switch type {
        case .comment:
            await createPostNoti(userId: receiveUser.nameID, type: "comment", postID: targetPostID , message: message)
            
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 댓글을 남겼습니다: \"\(message)\""
                )
            }
        case .facemoji:
            await createPostNoti(userId: receiveUser.nameID, type: "facemoji", postID: targetPostID, message: "")
            
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 페이스모지를 남겼습니다"
                )
            }
        case .heart:
            await createPostNoti(userId: receiveUser.nameID, type: "heart", postID: targetPostID, message: "")
            
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 ❤️로 공감했습니다"
                )
            }
        }
    }
    
    // 포스트 정보가 포함되지 않은 일반 알람
    func pushNoti(receiveUser: User, type: NotiType) async {
        switch type {
        case .follow:
            await createNoti(userId: receiveUser.nameID, type: "follow")
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 팔로우 하기 시작했습니다"
                )
            }
        case .surfer:
            await createNoti(userId: receiveUser.nameID, type: "surfer")
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 서퍼🏄🏼‍♀️로 지정했습니다"
                )
            }
        case .requestSurfing:
            await createNoti(userId: receiveUser.nameID, type: "requestSurfing")
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님에게 파도를 보내고싶어합니다🌊 확인해주세요"
                )
            }
        }
    }
    
    // 이미지 알람은 실험중
    func pushNotiWithImage(receiveUser: User, type: NotiType) async { // 실험중임
        if receiveUser.nameID != userNameID {
            PushNotificationManager.shared.sendPushNotificationWithImage(
                toFCMToken: receiveUser.fcmToken,
                title: "PADO",
                body: "\(userNameID)님이 회원님의 파도에 ❤️로 공감했습니다",
                imageUrl: receiveUser.profileImageUrl ?? ""
            )
        }
    }
    
    // 포스트 노티 컬렉션 생성 메서드
    func createPostNoti(userId: String, type: String, postID: String, message: String) async {
        let notificationRef = db.collection("users").document(userId).collection("notifications").document("\(type)-\(postID)")
        let notificationData: [String: Any] = [
            "type": type,
            "message": message,
            "createdAt": FieldValue.serverTimestamp(),
            "read": false
        ]
        do {
            try await notificationRef.setData(notificationData)
        } catch {
            print("firebase notification collection add error : \(error)")
        }
    }
    
    // 노티 컬렉션 생성 메서드
    func createNoti(userId: String, type: String) async {
        let notificationRef = db.collection("users").document(userId).collection("notifications").document("\(type)-\(userNameID)")
        let notificationData: [String: Any] = [
            "type": type,
            "createdAt": FieldValue.serverTimestamp(),
            "read": false
        ]
        do {
            try await notificationRef.setData(notificationData)
        } catch {
            print("firebase notification collection add error : \(error)")
        }
    }
}

