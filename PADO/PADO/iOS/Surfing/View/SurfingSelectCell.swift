//
//  SuferSelectCell.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import Kingfisher

import SwiftUI

struct SurfingSelectCell: View {
    @ObservedObject var followVM: FollowViewModel
    
    @State private var surfingProfileUrl: String?
    @State private var surfingID: String = ""
    @State private var surfingUsername: String = ""
    
    let cellUserId: String
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                Button {
                    followVM.selectSurfingID = surfingID
                    followVM.selectSurfingUsername = surfingUsername
                    followVM.selectSurfingProfileUrl = surfingProfileUrl ?? ""
                    followVM.showSurfingList.toggle()
                } label: {
                    if let imageUrl = surfingProfileUrl {
                        KFImage(URL(string: imageUrl))
                            .fade(duration: 0.5)
                            .placeholder{
                                Image("defaultProfile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    } else {
                        Image("defaultProfile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .foregroundStyle(Color(.systemGray4))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        if !surfingUsername.isEmpty {
                            Text(surfingID)
                                .font(.system(.subheadline,
                                              weight: .semibold))
                            
                            Text(surfingUsername)
                                .font(.system(.footnote))
                                .foregroundStyle(Color(.systemGray))
                        } else {
                            Text(surfingID)
                                .font(.system(.subheadline, 
                                              weight: .semibold))
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark")
                        .font(.system(.subheadline))
                        .foregroundStyle(.white)
                }
            }
            .padding(5)
            .onAppear {
                Task {
                    let updateUserData = UpdateUserData()
                    if let userProfile = await updateUserData.getOthersProfileDatas(id: cellUserId) {
                        self.surfingID = userProfile.nameID
                        self.surfingUsername = userProfile.username
                        self.surfingProfileUrl = userProfile.profileImageUrl ?? ""
                    }
                }
            }
        }
    }
}
