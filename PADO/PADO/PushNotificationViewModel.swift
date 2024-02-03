//
//  PushNotificationViewModel.swift
//  PADO
//
//  Created by 황민채 on 2/3/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class PushNotificationViewModel: ObservableObject {
    @Published var notiArray: [Noti] = []
    @Published var documentID: String = ""
    
    let db = Firestore.firestore()
    
    func pushNoti(sendUser: User, receiveUser: User) async {
        let noti = Noti(sendUserID: sendUser.nameID,
                        sendUserFcmToken: sendUser.fcmToken ,
                        receiveUserId: receiveUser.nameID,
                        receiveUserFcmToken: receiveUser.fcmToken ,
                        createAt: Timestamp()
        )
        
        await createNoti(id: receiveUser.nameID)
        
//        if let token = receiveUser.fcmToken,
//           let noti = receiveUser.
    }
    // 노티컬렉션에 상대방ID 넣어줌
    private func createNoti(id: String) async {
        do {
            try await
            db.collection("users").document(userNameID).collection("notification").document(id).setData(["notification": id])
        } catch {
            print("firebase notification collection add error : \(error)")
        }
    }
    
    @MainActor
    func pushCommentNoti(noti: Noti) async {
        // 이 내부에서 send, receive 관련 내용을 변경해주고 이제 그걸 파베에 올려서 push noti 어쩌구 불러서 보내줌
    }
}
