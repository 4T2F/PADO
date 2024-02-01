//
//  BlueButtonView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct BlueButtonView: View {
    
    let cellUserId: String
    @State var buttonActive: Bool = true
    let activeText: String
    let unActiveText: String
    let widthValue: CGFloat
    let heightValue: CGFloat
    
    let updateFollowData: UpdateFollowData
    
    var body: some View {
        Button(action: {
            if buttonActive {
                Task {
                    await updateFollowData.unfollowUser(id: cellUserId)
                }
            } else {
                Task {
                    await updateFollowData.followUser(id: cellUserId)
                }
            }
            buttonActive.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: widthValue, height: heightValue)
                    .foregroundStyle(buttonActive ? .modalBlackButton : Color(.systemBlue))
                
                HStack {
                    buttonActive ?
                    Text(unActiveText)
                        .foregroundStyle(.white)
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
                self.buttonActive = await updateFollowData.checkFollowStatus(id: cellUserId)
            }
        }
    }
}

