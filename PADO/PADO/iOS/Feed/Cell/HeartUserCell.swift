//
//  HeartUserCell.swift
//  PADO
//
//  Created by 최동호 on 2/25/24.
//


import Kingfisher
import SwiftUI

struct HeartUserCell: View {
    @State var user: User
    @State var buttonActive: Bool = false
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                NavigationLink {
                    OtherUserProfileView(buttonOnOff: $buttonActive,
                                         user: user)
                } label: {
                    HStack(spacing: 0) {
                        CircularImageView(size: .medium,
                                          user: user)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.nameID)
                                .foregroundStyle(.white)
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            
                            if !user.username.isEmpty {
                                Text(user.username)
                                    .font(.system(.subheadline, weight: .regular))
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            
            
            if user.nameID != userNameID {
                FollowButtonView(buttonActive: $buttonActive, 
                                 cellUser: user,
                                 activeText: "팔로우",
                                 unActiveText: "팔로우 취소",
                                 widthValue: 85,
                                 heightValue: 28,
                                 buttonType: ButtonType.unDirect)
                .padding(.horizontal)
            }
            
        }
        .padding(.vertical, -8)
        .padding(.horizontal)
        // contentShape 를 사용해서 H스택 전체적인 부분에 대해 패딩을 줌
        .contentShape(Rectangle())
    }
}
