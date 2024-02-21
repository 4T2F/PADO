//
//  SelectPadoRideUser.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct SelectPadoRideUserCell: View {
    var body: some View {
        NavigationLink {
            SelectUserView()
        } label: {
            VStack {
                Divider()
                    .padding(.bottom, 8)
                
                HStack {
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .foregroundStyle(Color(.systemGray4))
                    VStack(alignment: .leading, spacing: 4) {
                        // 닉네임이 있으면 username, userID 다 넣고 닉네임 없으면 else로 userID만 넣는 조건문 넣기
                        Text("하나비")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("hanabi")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 5)
            
        }
        
    }
}

#Preview {
    SelectPadoRideUserCell()
}
