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
    
    @State var profileUser: User?
    @State var buttonOnOff: Bool = false
    @State var transitions: Bool = false
    @State private var followerUsername: String = ""
    @State private var followerProfileUrl: String = ""
    @State private var showingModal: Bool = false
    @State private var buttonActive: Bool = false
    
    let cellUserId: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
                NavigationLink {
                    if let user = profileUser {
                        OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                             user: user)
                    }
                } label: {
                    HStack(spacing: 0) {
                        if let imageUrl = URL(string: followerProfileUrl) {
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
                                .font(.system(.subheadline, weight: .medium))
                                .foregroundStyle(.white)
                            
                            if !followerUsername.isEmpty {
                                Text(followerUsername)
                                    .font(.system(.subheadline, weight: .regular))
                                    .foregroundStyle(Color(.systemGray))
                            }
                        } //: VSTACK
                    }
                    
                    Spacer()
            }
            
            Spacer()
            
            if cellUserId != userNameID {
                if let cellUser = profileUser {
                    FollowButtonView(buttonActive: $buttonOnOff, 
                                     cellUser: cellUser,
                                     activeText: "팔로우",
                                     unActiveText: "팔로우 취소",
                                     widthValue: 85,
                                     heightValue: 28,
                                     buttonType: ButtonType.unDirect)
                    .padding(.horizontal)
                }
            }
            
        } // :HSTACK
        .padding(.horizontal)
        .padding(.vertical, -8)
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let userProfile = await updateUserData.getOthersProfileDatas(id: cellUserId) {
                    self.followerUsername = userProfile.username
                    self.followerProfileUrl = userProfile.profileImageUrl ?? ""
                    self.profileUser = userProfile
                }
                self.buttonOnOff = UpdateFollowData.shared.checkFollowingStatus(id: cellUserId)
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
