//
//  BlueButtonView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct BlueButtonView: View {
    
    let cellUserId: String
    @Binding var buttonActive: Bool
    let activeText: String
    let unActiveText: String
    let widthValue: CGFloat
    let heightValue: CGFloat
    
    let updateFollowData = UpdateFollowData()
    
    var body: some View {
        Button(action: {
            if !buttonActive {
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
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: widthValue, height: heightValue)
                    .foregroundStyle(buttonActive ?  .blueButton : .grayButton )
                
                HStack {
                    buttonActive ?
                    Text(activeText)
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    :
                    Text(unActiveText)
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                }
                .padding(.horizontal)
            }
        }
  
    }
}

