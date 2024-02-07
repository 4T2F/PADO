//
//  FollowerCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowNotificationCell: View {
    @State var sendUserProfileUrl: String = ""
    @State var buttonActive: Bool = false
    @State var name = ""
    
    var notification: Noti
    let updateFollowData = UpdateFollowData()
    
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
                Text("\(notification.sendUser)님이 회원님을 팔로우 하기 시작했습니다. ")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                +
                Text(TimestampDateFormatter.formatDate(notification.createdAt))
                    .font(.system(size: 12))
                    .foregroundStyle(Color(.systemGray))
            }
            
            Spacer()
            
            BlueButtonView(cellUserId: notification.sendUser,
                           buttonActive: $buttonActive,
                           activeText: "팔로우",
                           unActiveText: "팔로잉",
                           widthValue: 85,
                           heightValue: 30,
                           updateFollowData: updateFollowData)
        }
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let sendUserProfile = await updateUserData.getOthersProfileDatas(id: notification.sendUser) {
                    self.sendUserProfileUrl = sendUserProfile.profileImageUrl ?? ""
                }
            }
        }
    }
}
// 아래 로직 추가해야함
// self.buttonOnOff = await updateFollowData.checkFollowStatus(id: searchCellID)
