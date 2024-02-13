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
    @State var profileUser: User?
    
    @State var buttonActive: Bool = false
    
    let cellUserId: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                NavigationLink {
                    if let user = profileUser {
                        OtherUserProfileView(buttonOnOff: $buttonActive,
                                             user: user)
                    }
                } label: {
                    HStack(spacing: 0) {
                        if let imageUrl = URL(string: followingProfileUrl) {
                            KFImage.url(imageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(40)
                                .padding(.trailing)
                        } else {
                            Image("defaultProfile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(40)
                                .padding(.trailing)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(cellUserId)
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            if !followingUsername.isEmpty {
                                Text(followingUsername)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(Color(.systemGray))
                            }
                        } //: VSTACK
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            if cellUserId != userNameID {
                BlueButtonView(cellUserId: cellUserId,
                               buttonActive: $buttonActive,
                               activeText: "팔로우",
                               unActiveText: "팔로우 취소",
                               widthValue: 85,
                               heightValue: 28)
                .padding(.horizontal)
            }
            
        } // :HSTACK
        .padding(.vertical, -8)
        .padding(.horizontal)
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let userProfile = await updateUserData.getOthersProfileDatas(id: cellUserId) {
                    self.followingUsername = userProfile.username
                    self.followingProfileUrl = userProfile.profileImageUrl ?? ""
                    self.profileUser = userProfile
                    print("유저: \(String(describing: profileUser))")
                }
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
