//
//  ReportCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct SurferNotificationCell: View {
    @State var sendUserProfileUrl: String = ""
    @State private var buttonActive: Bool = false
    @State var name = ""
    
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
                    Text("\(notification.sendUser)님이 회원님을 서퍼로 지정했습니다. ")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    +
                    Text(TimestampDateFormatter.formatDate(notification.createdAt))
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.systemGray))
                }
            }
            
            Spacer()
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

