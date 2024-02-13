//
//  BlueButtonView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct FollowButtonView: View {
    
    let cellUserId: String
    @Binding var buttonActive: Bool
    let activeText: String
    let unActiveText: String
    let widthValue: CGFloat
    let heightValue: CGFloat
    
    var body: some View {
        Button(action: {
            if buttonActive {
                Task {
                    await UpdateFollowData.shared.unfollowUser(id: cellUserId)
                }
                buttonActive.toggle()
            } else if !userNameID.isEmpty {
                Task {
                    await UpdateFollowData.shared.followUser(id: cellUserId)
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
                self.buttonActive = UpdateFollowData.shared.checkFollowingStatus(id: cellUserId)
            }
        }
    }
}

