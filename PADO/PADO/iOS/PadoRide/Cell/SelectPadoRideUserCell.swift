//
//  SelectPadoRideUser.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct SelectPadoRideUserCell: View {
    @State var user: User?
    @State private var fetchUserData: Bool = false
    
    let id: String
    
    var body: some View {
        NavigationLink {
            if fetchUserData {
                if let user = user {
                    SelectUserView(user: user)
                }
            }
        } label: {
            VStack {
                Divider()
                    .padding(.vertical, 6)
                
                HStack {
                    if let user = user {
                        CircularImageView(size: .padoRideSize,
                                          user: user)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            // 닉네임이 있으면 username, userID 다 넣고 닉네임 없으면 else로 userID만 넣는 조건문 넣기
                            if user.username.isEmpty {
                                Text(user.nameID)
                                    .font(.system(.subheadline, 
                                                  weight: .semibold))
                                    .foregroundStyle(.white)
                            } else {
                                Text(user.nameID)
                                    .font(.system(.subheadline, 
                                                  weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text(user.username)
                                    .font(.system(.footnote))
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(.subheadline))
                            .foregroundStyle(.white)
                    }
                }
            }
            .onAppear {
                Task {
                    if let user = await UpdateUserData.shared.getOthersProfileDatas(id: id) {
                        self.user = user
                        fetchUserData = true
                    }
                }
            }
        }
    }
}
