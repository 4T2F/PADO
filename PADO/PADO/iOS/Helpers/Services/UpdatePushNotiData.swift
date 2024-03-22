//
//  UpdatePushNotiData.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import FirebaseFirestore

import Foundation

class UpdatePushNotiData {
    static let shared = UpdatePushNotiData()
    
    private init() { }
    
    let db = Firestore.firestore()
    
    // 포스트의 정보가 포함된 경우 푸시 알람(하위컬렉션 이름을 포스트이름으로 하기 위함)
    func pushPostNoti(targetPostID: String, receiveUser: User, type: PostNotiType, message: String, post: Post) async {
        switch type {
        case .comment:
            if receiveUser.nameID != userNameID {
                await createPostNoti(userId: receiveUser.nameID, type: "comment", postID: targetPostID, message: message)
            }
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotificationWithPost(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 댓글을 남겼습니다: \"\(message)\"",
                    categoryIdentifier: "post",
                    post: post
                )
            }
        case .replyComment:
            if receiveUser.nameID != userNameID {
                await createPostNoti(userId: receiveUser.nameID, type: "replyComment", postID: targetPostID, message: message)
            }
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotificationWithPost(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 댓글에 답글을 남겼습니다: \"\(message)\"",
                    categoryIdentifier: "post",
                    post: post
                )
            }
        case .photoMoji:
            if receiveUser.nameID != userNameID {
                await createPostNoti(userId: receiveUser.nameID, type: "facemoji", postID: targetPostID, message: "")
            }
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotificationWithPost(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 포토모지를 남겼습니다",
                    categoryIdentifier: "post",
                    post: post
                )
            }
        case .heart:
            if receiveUser.nameID != userNameID {
                await createPostNoti(userId: receiveUser.nameID, type: "heart", postID: targetPostID, message: "")
            }
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotificationWithPost(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 ❤️로 공감했습니다",
                    categoryIdentifier: "post",
                    post: post
                )
            }
        case .requestSurfing:
            await createPostNoti(userId: receiveUser.nameID, type: "requestSurfing", postID: targetPostID, message: message)
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotificationWithPost(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님에게 파도를 보냈습니다",
                    categoryIdentifier: "post",
                    post: post
                )
            }
        case .padoRide:
            await createPostNoti(userId: receiveUser.nameID, type: "padoRide", postID: targetPostID, message: message)
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotificationWithPost(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 파도탔습니다",
                    categoryIdentifier: "post",
                    post: post
                )
            }
        }
    }
    
    // 포스트 정보가 포함되지 않은 일반 푸시 알람 함수
    func pushNoti(receiveUser: User, type: NotiType, sendUser: User, message: String) async {
        switch type {
        case .follow:
            await createNoti(userId: receiveUser.nameID, type: "follow")
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 팔로우 하기 시작했습니다",
                    categoryIdentifier: "profile",
                    user: sendUser
                )
            }
        case .surfer:
            await createNoti(userId: receiveUser.nameID, type: "surfer")
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 서퍼🏄🏼‍♀️로 지정했습니다",
                    categoryIdentifier: "profile",
                    user: sendUser
                )
            }
        case .postit:
            if receiveUser.nameID != userNameID {
                await createPostitNoti(userId: receiveUser.nameID, type: "postit", message: message)
            }
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPostitPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 방명록에 글을 남겼습니다: \(message)",
                    categoryIdentifier: "postit",
                    userID: receiveUser.id ?? "", // 방명록 당사자의 정보(id 만)
                    userUrl: sendUser.profileImageUrl ?? "" // 보내는 당사자의 프로필이미지
                )
            }
        }
    }
    // 포스트 노티 컬렉션 생성 메서드
    func createPostNoti(userId: String, type: String, postID: String, message: String) async {
        let notificationRef = db.collection("users").document(userId).collection("notifications").document("\(type)-\(postID)-\(message)")
        let notificationData: [String: Any] = [
            "type": type,
            "postID": postID,
            "sendUser": userNameID,
            "message": message,
            "createdAt": FieldValue.serverTimestamp(),
            "read": false
        ]
        do {
            try await notificationRef.setData(notificationData)
            print("파베 등록 완료!")
        } catch {
            print("firebase notification collection add error : \(error)")
        }
    }
    // 노티 컬렉션 생성 메서드
    func createNoti(userId: String, type: String) async {
        let notificationRef = db.collection("users").document(userId).collection("notifications").document("\(type)-\(userNameID)")
        let notificationData: [String: Any] = [
            "type": type,
            "sendUser": userNameID,
            "createdAt": FieldValue.serverTimestamp(),
            "read": false
        ]
        do {
            try await notificationRef.setData(notificationData)
        } catch {
            print("firebase notification collection add error : \(error)")
        }
    }
    
    func createPostitNoti(userId: String, type: String, message: String) async {
        let notificationRef = db.collection("users").document(userId).collection("notifications").document("\(type)-\(userNameID)-\(message)")
        let notificationData: [String: Any] = [
            "type": type,
            "sendUser": userNameID,
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

