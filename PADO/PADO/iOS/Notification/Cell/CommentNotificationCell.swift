//
//  CommentNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct CommentNotificationCell: View {
    @State var sendUserProfileUrl: String = ""
    
    var notification: Noti
    
    var body: some View {
        HStack(spacing: 0) {
            if let image = URL(string: sendUserProfileUrl) {
                KFImage(image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(.trailing)
            } else {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(.trailing)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(notification.sendUser)님의 회원님의 파도에 댓글을 남겼습니다: \(notification.message ?? "") ")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    +
                    Text(notification.createdAt.formatDate(notification.createdAt))
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.systemGray))
                }
            }
            
            Spacer()
        }
        .onAppear {
            Task {
                if let sendUserProfile = await UpdateUserData.shared.getOthersProfileDatas(id: notification.sendUser) {
                    self.sendUserProfileUrl = sendUserProfile.profileImageUrl ?? ""
                }
            }
        }
    }
}
