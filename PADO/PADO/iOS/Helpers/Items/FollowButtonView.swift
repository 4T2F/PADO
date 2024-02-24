//
//  BlueButtonView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

enum ButtonType {
    case direct
    case unDirect
}

struct FollowButtonView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    let cellUser: User
    @Binding var buttonActive: Bool
    let activeText: String
    let unActiveText: String
    let widthValue: CGFloat
    let heightValue: CGFloat
    let buttonType: ButtonType
    @State private var isShowingLoginPage = false
    
    var body: some View {
        Button(action: {
            if !blockFollow(id: cellUser.nameID) {
                if buttonActive {
                    Task {
                        switch buttonType {
                        case .direct:
                            await UpdateFollowData.shared.directUnfollowUser(id: cellUser.nameID)
                        case .unDirect:
                            await UpdateFollowData.shared.unfollowUser(id: cellUser.nameID)
                        }
                    }
                    buttonActive.toggle()
                } else if userNameID.isEmpty {
                    isShowingLoginPage = true
                } else {
                    Task {
                        await UpdateFollowData.shared.followUser(id: cellUser.nameID)
                        if let currentUser = viewModel.currentUser {
                            await UpdatePushNotiData.shared.pushNoti(receiveUser: cellUser, type: .follow, sendUser: currentUser, message: "")
                        }
                        
                    }
                    buttonActive.toggle()
                }
            }
        }) {
            ZStack {
                Group {
                    buttonActive ?
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.gray, lineWidth: 1)
                        .frame(width: widthValue, height: heightValue)
                        .foregroundStyle(.clear)
                    :
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.white, lineWidth: 1)
                        .frame(width: widthValue, height: heightValue)
                        .foregroundStyle(.clear)
                }
                HStack {
                    buttonActive ?
                    Text(unActiveText)
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                    :
                    Text(activeText)
                        .foregroundStyle(.white)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
            }
            
        }
        .sheet(isPresented: $isShowingLoginPage,
               content: {
            StartView(isShowStartView: $isShowingLoginPage)
                .presentationDragIndicator(.visible)
        })
        .onAppear {
            Task {
                self.buttonActive = UpdateFollowData.shared.checkFollowingStatus(id: cellUser.nameID)
            }
        }
    }
    
    private func blockFollow(id: String) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return blockedUserIDs.contains(id)
    }
    
}



