//
//  NotificationCellView.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import SwiftUI

struct NotificationCell: View {
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var feedVM: FeedViewModel
    
    var notification: Noti
    
    var body: some View {
        switch notification.type { // 노티의 타입마다 분기처리
        case "comment":
            CommentNotificationCell(profileVM: profileVM,
                                    feedVM: feedVM,
                                    notification: notification)
        case "heart":
            HeartNotificationCell(profileVM: profileVM,
                                  feedVM: feedVM,
                                  notification: notification)
        case "facemoji":
            FacemojiNotificationCell(profileVM: profileVM,
                                     feedVM: feedVM,
                                     notification: notification)
        case "follow":
            FollowNotificationCell(notification: notification)
        case "requestSurfing":
            RequestSurfingNotificationCell(profileVM: profileVM,
                                           feedVM: feedVM,
                                           notification: notification)
        case "surfer":
            SurferNotificationCell(notification: notification)
        case "postit":
            PostitNotificationCell(notification: notification)
        case "padoRide":
            PadoRideNotificationCell(profileVM: profileVM,
                                     feedVM: feedVM,
                                     notification: notification)
        default:
            Text(notification.message ?? "") // 기본 전체 알람시 보여줄 셀
        }
    }
}

