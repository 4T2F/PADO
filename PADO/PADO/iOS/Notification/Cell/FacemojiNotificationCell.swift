//
//  FacemojiNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct FacemojiNotificationCell: View {
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var notiVM: NotificationViewModel
    
    var notification: Noti
    
    var body: some View {
        Button {
            notiVM.showFacemojiPost = true
        } label: {
            HStack(spacing: 0) {
                if let user = notiVM.notiUser[notification.sendUser] {
                    CircularImageView(size: .medium,
                                           user: user)
                    .padding(.trailing, 10)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(notification.sendUser)님이 회원님의 파도에 포토모지를 남겼습니다. ")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        +
                        Text(notification.createdAt.formatDate(notification.createdAt))
                            .font(.system(.footnote))
                            .foregroundStyle(Color(.systemGray))
                    }
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                }
                Spacer()
                
            }
        }
        .sheet(isPresented: $notiVM.showFacemojiPost) {
            if let postID = notification.postID,
               let post = notiVM.notiPosts[postID] {
                SelectPostCell(feedVM: feedVM,
                               post: .constant(post))
                .presentationDragIndicator(.visible)
            }
        }
    }
}
