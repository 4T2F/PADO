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
    
    // MARK: - BODY
    var body: some View {
        HStack {
            KFImage.url(URL(string: followingProfileUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(70)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text(cellUserId)
                    .font(.system(size: 18, weight: .semibold))
                if !followingUsername.isEmpty {
                    Text(followingUsername)
                        .font(.system(size: 14, weight: .semibold))
                }
            } //: VSTACK
            
            Spacer()
            
            BlueButtonView(cellUserId: cellUserId, buttonActive: $buttonActive, activeText: "팔로우", unActiveText: "팔로잉", widthValue: 80, heightValue: 30)
                .padding(.horizontal)
            
        } //: HSTACK
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
