//
//  SuferSelectCell.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import Kingfisher
import SwiftUI

struct SuferSelectCell: View {
    // MARK: - PROPERTY
    @ObservedObject var followVM: FollowViewModel
    
    @State private var sufferProfileUrl: String?
    @State private var sufferID: String = ""
    @State private var sufferNickName: String = ""
    
    let cellUserId: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            if let imageUrl = sufferProfileUrl {
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
                Text(sufferID)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(sufferNickName)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.systemGray4))
            }
            .padding(.horizontal, 8)
            Spacer()
            
            Button {
                followVM.selectSufferID = sufferID
                followVM.selectSufferNickName = sufferNickName
                followVM.selectSufferProfileUrl = sufferProfileUrl ?? ""
                followVM.showsufferList.toggle()
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
                    self.sufferID = userProfile.nameID
                    self.sufferNickName = userProfile.username
                    self.sufferProfileUrl = userProfile.profileImageUrl ?? ""
                }
            }
        }
    }
}
