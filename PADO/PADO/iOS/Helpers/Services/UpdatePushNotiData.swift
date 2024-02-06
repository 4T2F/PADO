//
//  UpdatePushNotiData.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

enum NotiType {
    case comment
    case facemoji
    case heart
    case follow
    case surfer
    case requestSurfing
}

class UpdatePushNotiData {
    let db = Firestore.firestore()
    
    func pushNoti(receiveUser: User, type: NotiType) async {
        // await createFollowNoti(id: receiveUser.nameID)
        switch type {
        case .comment:
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" { // 이건 문제가 있음 .... receiveUser 의 alertAccept 값이 보내는 시점에 업데이트 되지 않음
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 댓글을 남겼습니다"
                )
            }
        case .facemoji:
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 페이스모지를 남겼습니다"
                )
            }
        case .heart:
            if receiveUser.nameID != userNameID && receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님의 파도에 ❤️로 공감했습니다"
                )
            }
        case .follow:
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 팔로우 하기 시작했습니다"
                )
            }
        case .surfer:
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님을 서퍼로 지정했습니다"
                )
            }
        case .requestSurfing:
            if receiveUser.alertAccept == "yes" {
                PushNotificationManager.shared.sendPushNotification(
                    toFCMToken: receiveUser.fcmToken,
                    title: "PADO",
                    body: "\(userNameID)님이 회원님에게 파도를 보내고싶어합니다! 확인해주세요"
                )
            }
        }
    }
    
    func pushNotiWithImage(receiveUser: User, type: NotiType) async {
        if receiveUser.nameID != userNameID {
            PushNotificationManager.shared.sendPushNotificationWithImage(
                toFCMToken: receiveUser.fcmToken,
                title: "PADO",
                body: "\(userNameID)님이 회원님의 파도에 ❤️로 공감했습니다",
                imageUrl: receiveUser.profileImageUrl ?? ""
            )
        }
    }
    // 노티컬렉션에 상대방ID 넣어줌
    func createFollowNoti(id: String) async {
        do {
            try await
            db.collection("users").document(id).collection("notification").document(userNameID).setData(["notification": userNameID])
        } catch {
            print("firebase notification collection add error : \(error)")
        }
    }
}

