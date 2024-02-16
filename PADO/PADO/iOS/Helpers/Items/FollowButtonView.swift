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
    
    let cellUserId: String
    @Binding var buttonActive: Bool
    let activeText: String
    let unActiveText: String
    let widthValue: CGFloat
    let heightValue: CGFloat
    let buttonType: ButtonType
    
    @State private var isShowingLoginPage: Bool = false
    
    var body: some View {
        Button(action: {
            if buttonActive {
                Task {
                    switch buttonType {
                    case .direct:
                        await UpdateFollowData.shared.directUnfollowUser(id: cellUserId)
                    case .unDirect:
                        await UpdateFollowData.shared.unfollowUser(id: cellUserId)
                    }
                }
                buttonActive.toggle()
            } else if !userNameID.isEmpty {
                Task {
                    await UpdateFollowData.shared.followUser(id: cellUserId)
                }
                buttonActive.toggle()
            } else {
                isShowingLoginPage = true
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
        .sheet(isPresented: $isShowingLoginPage, content: {
            StartView()
                .presentationDragIndicator(.visible)
        })
        .onAppear {
            Task {
                self.buttonActive = UpdateFollowData.shared.checkFollowingStatus(id: cellUserId)
            }
        }
    }
}

