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
    
    var body: some View {
        Button(action: {
            if buttonActive {
                Task {
                    switch buttonType {
                    case .direct:
                        await UpdateFollowData.shared.directUnfollowUser(id: cellUser.nameID)
                    case .unDirect:
                        await UpdateFollowData.shared.unfollowUser(id: cellUser.nameID)
                    }
                    if let currentUser = viewModel.currentUser {
                        await UpdatePushNotiData.shared.pushNoti(receiveUser: cellUser, type: .follow, sendUser: currentUser)
                    }
                }
                buttonActive.toggle()
            } else if !userNameID.isEmpty {
                Task {
                    await UpdateFollowData.shared.followUser(id: cellUser.nameID)
                }
                buttonActive.toggle()
            } else {
                // 가입 모달 띄우기
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.gray, lineWidth: 1)
                    .frame(width: widthValue, height: heightValue)
                    .foregroundStyle(.clear)
                
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
        .onAppear {
            Task {
                self.buttonActive = UpdateFollowData.shared.checkFollowingStatus(id: cellUser.nameID)
            }
        }
    }
}

