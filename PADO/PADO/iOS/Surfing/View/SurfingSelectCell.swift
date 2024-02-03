//
//  SuferSelectCell.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import Kingfisher
import SwiftUI

struct SurfingSelectCell: View {
    // MARK: - PROPERTY
    @ObservedObject var followVM: FollowViewModel
    
    @State private var surfingProfileUrl: String?
    @State private var surfingID: String = ""
    @State private var surfingUsername: String = ""
    
    let cellUserId: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            if let imageUrl = surfingProfileUrl {
                KFImage(URL(string: imageUrl))
                    .fade(duration: 0.5)
                    .placeholder{
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image("defaultProfile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .foregroundStyle(Color(.systemGray4))
            }
            VStack(alignment: .leading) {
                Text(surfingID)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(surfingUsername)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.systemGray4))
            }
            .padding(.horizontal, 8)
            Spacer()
            
            Button {
                followVM.selectSurfingID = surfingID
                followVM.selectSurfingUsername = surfingUsername
                followVM.selectSurfingProfileUrl = surfingProfileUrl ?? ""
                followVM.showSurfingList.toggle()
            } label: {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 14))
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
