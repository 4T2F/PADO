//
//  NotificationViewModel.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [Noti] = []
    @Published var hasNewNotifications = false // 새로운 알림 유무를 나타내는 변수 추가
    
    private let db = Firestore.firestore()
    
    func fetchNotifications() async {
        guard !userNameID.isEmpty else { return }
        let notificationsRef = db.collection("users").document(userNameID).collection("notifications")
        do {
            let snapshot = try await notificationsRef.order(by: "createdAt", descending: true).getDocuments()
            self.notifications = snapshot.documents.compactMap { document in
                try? document.data(as: Noti.self)
            }
            self.hasNewNotifications = notifications.contains { !$0.read }
        } catch {
            print("Error fetching notifications: \(error)")
        }
    }
    
    func markNotificationsAsRead() async {
        for notification in notifications where !notification.read {
            guard let notificationID = notification.id else { continue }
            let notificationRef = db.collection("users").document(userNameID).collection("notifications").document(notificationID)
            
            do {
                try await notificationRef.updateData(["read": true])
            } catch {
                print("Error updating notification read status: \(error)")
            }
        }
        
        // 모든 알림을 읽음으로 표시한 후 notifications 배열 업데이트
        await fetchNotifications()
    }
    
    func deleteAllNotifications() async {
        guard !userNameID.isEmpty else { return }
        let notificationsRef = db.collection("users").document(userNameID).collection("notifications")
        
        do {
            // notifications 서브콜렉션의 모든 문서를 가져옴
            let snapshot = try await notificationsRef.getDocuments()
            let batch = db.batch()
            snapshot.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            // batch 작업으로 모든 문서 삭제 실행
            try await batch.commit()
            
            // 알림 목록 업데이트
            await fetchNotifications()
        } catch {
            print("Error deleting all notifications: \(error)")
        }
    }
}
