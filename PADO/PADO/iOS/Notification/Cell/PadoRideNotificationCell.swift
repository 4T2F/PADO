//
//  PadoRideNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/17/24.
//

import Kingfisher
import SwiftUI

struct PadoRideNotificationCell: View {
    @StateObject var notiVM = NotificationViewModel.shared
    
    @ObservedObject var feedVM: FeedViewModel
    
    @State private var showPost = false
    
    var notification: Noti
    
    var body: some View {
        Button {
            showPost = true
        } label: {
            HStack(spacing: 0) {
                if let user = notiVM.notiUser[notification.sendUser] {
                    CircularImageView(size: .medium,
                                           user: user)
                    .padding(.trailing, 10)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(notification.sendUser)님에게 새로운 파도타기가 도착했어요 ")
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
                
                if let postID = notification.postID,
                   let post = notiVM.notiPosts[postID],
                   let image = URL(string: post.imageUrl) {
                    KFImage(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .sheet(isPresented: $showPost) {
            if let postID = notification.postID,
               let post = notiVM.notiPosts[postID] {
                SelectPostCell(feedVM: feedVM,
                               post: .constant(post))
                .presentationDragIndicator(.visible)
            }
        }
    }
}
