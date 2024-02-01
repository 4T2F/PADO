//
//  UserCellView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowingCellView: View {
    // MARK: - PROPERTY
    @State var followingUsername: String = ""
    @State var followingProfileUrl: String = ""
    
    @State private var buttonActive: Bool = false
    
    let cellUserId: String

    let updateFollowData: UpdateFollowData
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                KFImage.url(URL(string: followingProfileUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(cellUserId)
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    
                    if !followingUsername.isEmpty {
                        Text(followingUsername)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color(.systemGray))
                    }
                } //: VSTACK
            }
            
            Spacer()
            
            BlueButtonView(cellUserId: cellUserId,
                           activeText: "팔로우",
                           unActiveText: "팔로잉",
                           widthValue: 85,
                           heightValue: 30,
                           updateFollowData: updateFollowData)
                .padding(.horizontal)

        } // :HSTACK
        .padding(.vertical, -12)
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let userProfile = await updateUserData.getOthersProfileDatas(id: cellUserId) {
                    self.followingUsername = userProfile.username
                    self.followingProfileUrl = userProfile.profileImageUrl ?? ""
                }
            }
        }
    }
}
