//
//  FollowerCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowNotificationCell: View {
    @StateObject var notiVM = NotificationViewModel.shared
    
    @State private var buttonActive: Bool = false
    
    var notification: Noti
    
    var body: some View {
        if let user = notiVM.notiUser[notification.sendUser] {
            NavigationLink {
                OtherUserProfileView(buttonOnOff: $buttonActive,
                                     user: user)
            } label: {
                HStack(spacing: 0) {
                    CircularImageView(size: .medium,
                                      user: user)
                    .padding(.trailing, 10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(notification.sendUser)님이 회원님을 팔로우 하기 시작했습니다. ")
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
                    
                    FollowButtonView(cellUser: user,
                                     buttonActive: $buttonActive,
                                     activeText: "팔로우",
                                     unActiveText: "팔로우 취소",
                                     widthValue: 85,
                                     heightValue: 30,
                                     buttonType: ButtonType.direct)
                    
                }
            }
        }
    }
}
