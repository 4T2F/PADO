//
//  NotificationCellView.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import SwiftUI

struct NotificationCell: View {
    @ObservedObject var notiVM: NotificationViewModel
    
    var notification: Noti
    var openPostit: () -> Void
    
    var body: some View {
        switch notification.type { // 노티의 타입마다 분기처리
        case "comment":
            CommentNotificationCell(notiVM: notiVM, 
                                    notification: notification)
        case "replyComment":
            ReplyCommentNotificationCell(notiVM: notiVM, 
                                         notification: notification)
        case "heart":
            HeartNotificationCell(notiVM: notiVM, 
                                  notification: notification)
        case "facemoji":
            FacemojiNotificationCell(notiVM: notiVM, 
                                     notification: notification)
        case "follow":
            FollowNotificationCell(notiVM: notiVM, 
                                   notification: notification)
        case "requestSurfing":
            RequestSurfingNotificationCell(notiVM: notiVM,
                                           notification: notification)
        case "surfer":
            SurferNotificationCell(notiVM: notiVM, 
                                   notification: notification)
        case "postit":
            PostitNotificationCell(notiVM: notiVM,
                                   notification: notification,
                                   openPostit: openPostit)
        case "padoRide":
            PadoRideNotificationCell(notiVM: notiVM, 
                                     notification: notification)
        default:
            Text(notification.message ?? "") // 기본 전체 알람시 보여줄 셀
        }
    }
}

