//
//  FollowerSuggestionCell.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct FollowerSuggestionCell: View {
    
    let user: User
    @State var buttonActive: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 140, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.modal)
                .shadow(color: .black, radius: 0.8)
            
            VStack {
                CircularImageView(size: .xLarge,
                                  user: user)
                
                Text(user.nameID)
                    .font(.system(size: 14, weight: .medium))
                
                FollowButtonView(cellUser: user,
                                 buttonActive: $buttonActive,
                                 activeText: "팔로우",
                                 unActiveText: "팔로우 취소",
                                 widthValue: 100,
                                 heightValue: 30,
                                 buttonType: .direct)
            }
            .foregroundStyle(.white)
        }
        .onAppear {
            buttonActive = userFollowingIDs.contains(user.nameID)
        }
    }
}

