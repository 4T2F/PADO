//
//  FollowerOtherUserCellView.swift
//  PADO
//
//  Created by 최동호 on 2/2/24.
//

import Kingfisher
import SwiftUI

struct FollowerOtherUserCellView: View {
    @ObservedObject var followVM: FollowViewModel
    
    @State private var followerUsername: String = ""
    @State private var followerProfileUrl: String = ""
    @State private var showingModal: Bool = false
    @State var profileUser: User?
    
    let cellUserId: String
    
    @State var buttonOnOff: Bool = false
    @State private var buttonActive: Bool = false
    @State var transitions: Bool = false
    
    let updateFollowData: UpdateFollowData
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                NavigationLink {
                    if let user = profileUser {
                        OtherUserProfileView(buttonOnOff: $buttonOnOff, updateFollowData: updateFollowData,
                                             user: user)
                    }
                } label: {
                    if let imageUrl = URL(string: followerProfileUrl) {
                        KFImage.url(imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .cornerRadius(44)
                            .padding(.leading)
                    } else {
                        Image("defaultProfile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .cornerRadius(44)
                            .padding(.leading)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(cellUserId)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.leading, 4)
                        
                        if !followerUsername.isEmpty {
                            Text(followerUsername)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Color(.systemGray))
                                .padding(.leading, 4)
                        }
                    } //: VSTACK
                }
            }
            
            Spacer()
            
            if cellUserId != userNameID {
                BlueButtonView(cellUserId: cellUserId,
                               buttonActive: $buttonOnOff,
                               activeText: "팔로우",
                               unActiveText: "팔로우 취소",
                               widthValue: 85,
                               heightValue: 28,
                               updateFollowData: updateFollowData)
                .padding(.horizontal)
            }
            
        } // :HSTACK
        .padding(.vertical, -12)
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let userProfile = await updateUserData.getOthersProfileDatas(id: cellUserId) {
                    self.followerUsername = userProfile.username
                    self.followerProfileUrl = userProfile.profileImageUrl ?? ""
                    self.profileUser = userProfile
                }
                self.buttonOnOff = await updateFollowData.checkFollowStatus(id: cellUserId)
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
