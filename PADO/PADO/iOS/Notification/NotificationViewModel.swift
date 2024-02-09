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
    
    private let db = Firestore.firestore()

    func fetchNotifications() async {
        guard !userNameID.isEmpty else { return }
        let notificationsRef = db.collection("users").document(userNameID).collection("notifications")
        do {
            let snapshot = try await notificationsRef.order(by: "createdAt", descending: true).getDocuments()
            self.notifications = snapshot.documents.compactMap { document in
                try? document.data(as: Noti.self)
            }
        } catch {
            print("Error fetching notifications: \(error)")
        }
    }
}
