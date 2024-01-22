//
//  ProfileCell.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct ProfileCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            
            CircularImageView(size: .xxLarge)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("dearkang")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    
                    Text("@천랑성")
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius:4)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 88, height: 28)
                    Text("프로필 편집")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            }
            
            HStack {
                HStack {
                    Text("5")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text("wave time")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                } //: VSTACK
                
                Rectangle()
                    .foregroundStyle(Color(.systemGray2))
                    .frame(width: 1, height: 20)
                
                NavigationLink(destination: FollowView()) {
                    HStack {
                        Text("1")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        
                        Text("follower")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    } //: VSTACK
                }
                
                Rectangle()
                    .foregroundStyle(Color(.systemGray2))
                    .frame(width: 1, height: 20)
                
                NavigationLink(destination: FollowView()) {
                    HStack {
                        Text("1")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("following")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    } //: VSTACK
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileCell()
}
