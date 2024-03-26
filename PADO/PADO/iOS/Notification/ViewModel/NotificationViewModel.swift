//
//  NotificationViewModel.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import FirebaseFirestore

import SwiftUI

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Noti] = []
    @Published var notiPostListener: [String: ListenerRegistration] = [:]
    @Published var notiPosts: [String: Post] = [:]
    @Published var notiUser: [String: User] = [:]
    @Published var hasNewNotifications = false // 새로운 알림 유무를 나타내는 변수 추가
    @Published var lastFetchedDocument: DocumentSnapshot? = nil
    
    @Published var showFacemojiPost = false
    @Published var showHeartPost = false
    @Published var showReplyCommentPost = false
    @Published var showCommentPost = false
    @Published var showRequestSurfingPost = false
    @Published var showPadoRidePost = false
    
    
    
    
    private let db = Firestore.firestore()
    
    @MainActor
    func fetchNotifications() async {
        guard !userNameID.isEmpty else { return }
        
        lastFetchedDocument = nil
        
        let query = db.collection("users")
            .document(userNameID)
            .collection("notifications")
            .order(by: "createdAt", descending: true)
            .limit(to: 12)
        
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("users").document(userNameID).collection("notifications"),
                                                        query: query)
            
            self.lastFetchedDocument = documents.last
            
            self.notifications = documents.compactMap { document in
                try? document.data(as: Noti.self)
            }
            self.notifications = self.notifications.filter { !$0.sendUser.isEmpty }
            self.hasNewNotifications = notifications.contains { !$0.read }
            
            for notification in notifications {
                if let postID = notification.postID {
                    await fetchNotificationPostData(postID: postID)
                }
                if notiUser[notification.sendUser] != nil {
                    continue
                }
                if let user = await UpdateUserData.shared.getOthersProfileDatas(id: notification.sendUser) {
                    notiUser[notification.sendUser] = user
                }
            }
        } catch {
            print("Error fetching notifications: \(error)")
        }
    }
    
    @MainActor
    func fetchNotificationPostData(postID: String) async {
        guard !postID.isEmpty else { return }
        guard self.notiPosts[postID] == nil else { return }
        
        let query = db.collection("post").document(postID)
        
        notiPostListener[postID] = query.addSnapshotListener{ [weak self] documentSnapshot, error in
            guard let self = self else { return }
            guard let document = documentSnapshot, document.exists,
                  let post = try? document.data(as: Post.self) else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.notiPosts[postID] = post
        }
    }
  
    @MainActor
    func fetchMoreNotifications() async {
        guard !userNameID.isEmpty else { return }
        guard let lastDocument = lastFetchedDocument else { return }
        
        let query = db.collection("users")
            .document(userNameID)
            .collection("notifications")
            .order(by: "createdAt", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: 5)
        
        do {
            let documents = try await getDocumentsAsync(collection: db.collection("users").document(userNameID).collection("notifications"),
                                                        query: query)
            
            self.lastFetchedDocument = documents.last
            
            var documentsData = documents.compactMap { document in
                try? document.data(as: Noti.self)
            }
            
            documentsData = documentsData.filter { !$0.sendUser.isEmpty }
            for documentData in documentsData {
                self.notifications.append(documentData)
                if let postID = documentData.postID {
                    await fetchNotificationPostData(postID: postID)
                }
                if notiUser[documentData.sendUser] != nil {
                    continue
                }
                if let user = await UpdateUserData.shared.getOthersProfileDatas(id: documentData.sendUser) {
                    notiUser[documentData.sendUser] = user
                }
            }
        } catch {
            print("Error fetching notifications: \(error)")
        }
    }

    func stopAllPostListeners() {
        for (_, listener) in notiPostListener {
            listener.remove()
        }
        notiPostListener.removeAll()
        notiPosts.removeAll()
    }
    
    // Firestore의 getDocuments에 대한 비동기 래퍼 함수
    func getDocumentsAsync(collection: CollectionReference, query: Query) async throws -> [QueryDocumentSnapshot] {
        try await withCheckedThrowingContinuation { continuation in
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let querySnapshot = querySnapshot {
                    continuation.resume(returning: querySnapshot.documents)
                } else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    @MainActor
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
    
    @MainActor
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
