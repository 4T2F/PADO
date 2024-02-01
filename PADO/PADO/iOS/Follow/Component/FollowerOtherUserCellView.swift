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
    
    let cellUserId: String
    
    @State private var buttonActive: Bool = false
    @State var transitions: Bool = false
    
    let updateFollowData: UpdateFollowData
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                if let imageUrl = URL(string: followerProfileUrl) {
                    KFImage.url(imageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                        .padding(.horizontal)
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(cellUserId)
                        .font(.system(size: 14, weight: .semibold))
                    if !followerUsername.isEmpty {
                        Text(followerUsername)
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
                    self.followerUsername = userProfile.username
                    self.followerProfileUrl = userProfile.profileImageUrl ?? ""
                }
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
