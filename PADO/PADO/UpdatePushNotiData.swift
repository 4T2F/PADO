//
//  UpdatePushNotiData.swift
//  PADO
//
//  Created by 김명현, 황민채 on 2/3/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UpdatePushNotiData {
    
    let db = Firestore.firestore()
    
    func pushNoti(receiveUser: User) async {
        let noti = Noti(
//            sendUserID: sendUser.nameID,
//                        sendUserFcmToken: sendUser.fcmToken ,
                        receiveUserId: receiveUser.nameID,
                        receiveUserFcmToken: receiveUser.fcmToken ,
                        createAt: Timestamp()
        )
        
        await createFollowNoti(id: receiveUser.nameID)
        
        PushNotificationManager.shared.sendPushNotification(toFCMToken: receiveUser.fcmToken , title: "PADO", body: "안녕~~ 방금 너 팔로우 했어")
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

