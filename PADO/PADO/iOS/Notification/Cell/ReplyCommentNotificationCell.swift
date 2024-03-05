//
//  ReplyCommentNotificationCell.swift
//  PADO
//
//  Created by 최동호 on 2/27/24.
//

import Kingfisher
import SwiftUI

struct ReplyCommentNotificationCell: View {
    @ObservedObject var feedVM: FeedViewModel
    
    @State var sendUserProfileUrl: String = ""
    
    @State var sendPost: Post? = nil
    
    @State private var showPost = false
    
    var notification: Noti
    
    var body: some View {
        Button {
            if sendPost != nil {
                showPost = true
            }
        } label: {
            HStack(spacing: 0) {
                if let image = URL(string: sendUserProfileUrl) {
                    KFImage(image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        .padding(.trailing)
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        .padding(.trailing)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(notification.sendUser)님의 회원님의 댓글에 답글을 남겼습니다: \(notification.message ?? "") ")
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
        .sheet(isPresented: $showPost) {
            if let post = sendPost {
                SelectPostCell(feedVM: feedVM,
                                 post: post)
                .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            Task {
                if let sendUserProfile = await UpdateUserData.shared.getOthersProfileDatas(id: notification.sendUser) {
                    self.sendUserProfileUrl = sendUserProfile.profileImageUrl ?? ""
                }
                if let sendPost = await
                    UpdatePostData.shared.fetchPostById(postId: notification.postID ?? "") {
                    self.sendPost = sendPost
                }
            }
        }
    }
}
