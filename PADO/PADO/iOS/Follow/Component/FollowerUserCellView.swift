//
//  FollowerUserCellView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct FollowerUserCellView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var followVM: FollowViewModel
    
    @State private var followerUsername: String = ""
    @State private var followerProfileUrl: String = ""
    @State private var showingModal: Bool = false
    @State private var showingSurferModal: Bool = false
    @State var profileUser: User?
    
    let cellUserId: String
    let followerType: FollowerModalType
    
    enum SufferSet: String {
        case removesuffer = "서퍼 해제"
        case setsuffer = "서퍼 등록"
    }
    
    @State var buttonOnOff: Bool = false
    @State private var buttonActive: Bool = false
    @State var transitions: Bool = false
    
    let sufferset: SufferSet
    
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
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                        
                        if !followerUsername.isEmpty {
                            Text(followerUsername)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color(.systemGray))
                        }
                    } //: VSTACK
                }
                
                Spacer()
            }
            
            Spacer()
            
            switch followerType {
            case .surfer:
                Button {
                    showingSurferModal.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius:6)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 78, height: 28)
                        Text("서퍼 해제")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                    }
                    .sheet(isPresented: $showingSurferModal) {
                        FollowerModalAlert(followerUsername: "\(cellUserId)님을 서퍼 해제하시겠어요?",
                                           followerProfileUrl: followerProfileUrl,
                                           buttonText1: "서퍼 해제",
                                           onButton1: { await UpdateFollowData.shared.removeSurfer(id: cellUserId)})
                        .presentationDetents([.fraction(0.4)])
                        
                    }
                }
                .padding(.trailing)
                
            case .follower:
                Button {
                    Task {
                        await UpdateFollowData.shared.registerSurfer(id: cellUserId)
                        if let currentUser = viewModel.currentUser {
                            await UpdatePushNotiData.shared.pushNoti(receiveUser: profileUser!, type: .surfer, sendUser: currentUser, message: "")
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius:6)
                            .stroke(.white, lineWidth: 1)
                            .frame(width: 78, height: 28)
                        Text("서퍼 등록")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.trailing)
            }
            
            Button {
                showingModal.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(.trailing)
            }
            .sheet(isPresented: $showingModal) {
                FollowerModalAlert(followerUsername: "\(cellUserId)님을 팔로워에서 삭제하시겠어요?",
                                   followerProfileUrl: followerProfileUrl,
                                   buttonText1: "팔로워 삭제",
                                   onButton1: {
                    await UpdateFollowData.shared.removeFollower(id: cellUserId)
                })
                .presentationDetents([.fraction(0.4)])
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
                    print("유저: \(String(describing: profileUser))")
                }
                self.buttonOnOff = UpdateFollowData.shared.checkFollowingStatus(id: cellUserId)
            }
        }
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
