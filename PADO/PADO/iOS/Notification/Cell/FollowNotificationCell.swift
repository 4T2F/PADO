//
//  FollowerCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowNotificationCell: View {
    @State private var targetUser: User? = nil
    @State private var buttonActive: Bool = false
    @State private var buttonOnOff: Bool = false
    
    var notification: Noti
    
    var body: some View {
        NavigationLink {
            if let targetUser = targetUser {
                OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                     user: targetUser)
            }
        } label: {
            HStack(spacing: 0) {
                if let image = URL(string: targetUser?.profileImageUrl ?? "") {
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
                        Text("\(notification.sendUser)님이 회원님을 팔로우 하기 시작했습니다. ")
                            .font(.system(size: 14))
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
                
                if let targetUser = targetUser {
                    FollowButtonView(cellUser: targetUser,
                                     buttonActive: $buttonActive,
                                     activeText: "팔로우",
                                     unActiveText: "팔로우 취소",
                                     widthValue: 85,
                                     heightValue: 30,
                                     buttonType: ButtonType.direct)
                }
            }
            .onAppear {
                Task {
                    if let targetUser = await UpdateUserData.shared.getOthersProfileDatas(id: notification.sendUser) {
                        self.targetUser = targetUser
                    }
                    self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: notification.sendUser)
                }
            }
        }
    }
}
