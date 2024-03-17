//
//  UserProfileSection.swift
//  PADO
//
//  Created by 강치우 on 3/17/24.
//

import SwiftUI

struct UserProfileSection: View {
    @Binding var buttonOnOff: Bool
    
    var username: String
    var userId: String
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            NavigationLink {
                OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                     user: user)
            } label: {
                CircularImageView(size: .small,
                                  user: user)
            }
            
            NavigationLink {
                OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                     user: user)
            } label: {
                HStack {
                    if !user.username.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(username)님의 프로필")
                                .font(.system(.footnote))
                                .fontWeight(.medium)
                            
                            Text("@\(userId)")
                                .font(.system(.caption2))
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(userId)님의 프로필")
                                .font(.system(.footnote))
                                .fontWeight(.medium)
                            
                            Text("@\(userId)")
                                .font(.system(.caption2))
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(.footnote))
                        .foregroundStyle(.white)
                        .padding(.leading, 90)
                }
                .padding(10)
                .background(Color(.systemGray4).opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
}
