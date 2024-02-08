//
//  FacemojiNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct FacemojiNotificationCell: View {
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
                    Text("\(notification.sendUser)님이 회원님의 파도에 페이스모지를 남겼습니다. ")
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
