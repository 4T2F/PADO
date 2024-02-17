//
//  HeartNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct HeartNotificationCell: View {
    @ObservedObject var profileVM: ProfileViewModel
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
                        Text("\(notification.sendUser)님이 회원님의 파도에 ❤️로 공감했습니다. ")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        +
                        Text(notification.createdAt.formatDate(notification.createdAt))
                            .font(.system(size: 12))
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
                OnePostModalView(profileVM: profileVM,
                                 feedVM: feedVM,
                                 updateHeartData: UpdateHeartData(),
                                 post: post)
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
