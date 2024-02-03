//
//  FollowerUserCellView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowerUserCellView: View {
    @ObservedObject var followVM: FollowViewModel
    
    @State private var followerUsername: String = ""
    @State private var followerProfileUrl: String = ""
    @State private var showingModal: Bool = false
    @State var profileUser: User?
    
    let cellUserId: String
    let followerType: FollowerModalType
    
    enum SufferSet: String {
        case removesuffer = "서퍼 해제"
        case setsuffer = "서퍼 등록"
    }
    
    @State private var buttonActive: Bool = false
    @State var transitions: Bool = false
    
    let sufferset: SufferSet
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                NavigationLink {
                    if let user = profileUser {
                        OtherUserProfileView(user: user)
                    }
                } label: {
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
                            .foregroundStyle(.white)
                        if !followerUsername.isEmpty {
                            Text(followerUsername)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Color(.systemGray))
                        }
                    } //: VSTACK
                }
            }
            
            Spacer()
            
            Button {
                showingModal.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(.trailing)
            }
            .sheet(isPresented: $showingModal) {
                let updateFollowData = UpdateFollowData()
                switch followerType {
                case .surfer:
                    FollowerModalAlert(followerUsername: cellUserId,
                                       followerProfileUrl: followerProfileUrl,
                                       buttonText1: "서퍼 해제",
                                       onButton1: { await updateFollowData.removeSurfer(id: cellUserId)})
                    .presentationDetents([.fraction(0.4)])
                case .follower:
                    FollowerModalAlert(followerUsername: cellUserId,
                                       followerProfileUrl: followerProfileUrl,
                                       buttonText1: "서퍼 등록",
                                       buttonText2: "팔로워 삭제",
                                       onButton1: {
                        await updateFollowData.registerSurfer(id: cellUserId)
                        await UpdatePushNotiData().pushNoti(receiveUser: profileUser!, type: .surfer)
                    },
                                       onButton2: { 
                        await updateFollowData.removeFollower(id: cellUserId)
                    })
                    .presentationDetents([.fraction(0.4)])
                }
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
                    print("유저: \(String(describing: profileUser))")
                }
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
