//
//  FollowerSuggestionCell.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct FollowerSuggestionCell: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 140, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.modal)
                .shadow(color: .black, radius: 0.8)
            
            VStack {
                Image("defaultProfile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 66, height: 66)
                    .clipShape(Circle())
                    .foregroundStyle(Color(.systemGray4))
                    .padding(.bottom, 4)
                
                // 닉네임 있으면 둘 다, 닉네임 없으면 userID만 넣는 조건문
                Text("하나비") // username
                    .font(.system(size: 14, weight: .medium))
                Text("@hanabi") // userID
                    .font(.system(size: 12))
                    .foregroundStyle(Color(.systemGray))
                
                
                Button {
                    //
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 100, height: 30)
                            .foregroundStyle(.white)
                        
                        Text("팔로우")
                            .foregroundStyle(.black)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                    }
                }
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    FollowerSuggestionCell()
}
