//
//  NotificationObserver.swift
//  PADO
//
//  Created by 황민채 on 2/3/24.
//

import Foundation
import UserNotifications

final class NotificationObserver: ObservableObject {
    static let shared: NotificationObserver = NotificationObserver()

    @Published var newMessageID: String = ""

    func processNotification(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        if let gcmMessageID = userInfo["gcm.message_id"] as? String {
            self.newMessageID = gcmMessageID // 알림 id 는 메세지마다 다르기에 뷰 다시그리기 용으로 적합
        }
    }
}
