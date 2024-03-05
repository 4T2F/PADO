//
//  NotificationCellView.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import SwiftUI

struct NotificationCell: View {
    @ObservedObject var feedVM: FeedViewModel
    
    @State var post: Post
    
    var notification: Noti
    
    var body: some View {
        switch notification.type { // 노티의 타입마다 분기처리
        case "comment":
            CommentNotificationCell(feedVM: feedVM,
                                    notification: notification)
        case "replyComment":
            ReplyCommentNotificationCell(feedVM: feedVM,
                                    notification: notification)
        case "heart":
            HeartNotificationCell(feedVM: feedVM,
                                  notification: notification)
        case "facemoji":
            FacemojiNotificationCell(feedVM: feedVM,
                                     notification: notification)
        case "follow":
            FollowNotificationCell(notification: notification)
        case "requestSurfing":
            RequestSurfingNotificationCell(feedVM: feedVM,
                                           notification: notification)
        case "surfer":
            SurferNotificationCell(notification: notification)
        case "postit":
            PostitNotificationCell(notification: notification)
        case "padoRide":
            PadoRideNotificationCell(feedVM: feedVM,
                                     notification: notification)
        default:
            Text(notification.message ?? "") // 기본 전체 알람시 보여줄 셀
        }
    }
}

