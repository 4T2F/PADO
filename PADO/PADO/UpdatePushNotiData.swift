//
//  UpdatePushNotiData.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

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
        
        //await createFollowNoti(id: receiveUser.nameID)
        
        switch type {
        case .comment:
            PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "\(userNameID)님이 회원님의 파도에 댓글을 남겼습니다.")
        case .facemoji:
            PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "\(userNameID)님이 회원님의 파도에 페이스모지를 남겼습니다.")
        case .heart:
            PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "\(userNameID)님이 회원님의 파도를 좋아합니다.")
        case .follow:
            PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "\(userNameID)님이 회원님을 팔로우 하기 시작했습니다.")
        case .surfer:
            PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "\(userNameID)님이 회원님을 서퍼로  지정했습니다.")
        case .requestSurfing:
            PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "\(userNameID)님이 회원님에게 파도를 보내고싶어합니다. 확인해주세요.")
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
    
    @MainActor
    func pushCommentNoti(noti: Noti) async {
        // 이 내부에서 send, receive 관련 내용을 변경해주고 이제 그걸 파베에 올려서 push noti 어쩌구 불러서 보내줌
    }
}

