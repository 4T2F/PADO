//
//  RecordSearchCellView.swift
//  PADO
//
//  Created by 최동호 on 2/2/24.
//

import Kingfisher
import SwiftUI

struct RecordSearchCellView: View {
    // MARK: - PROPERTY
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var searchVM: SearchViewModel
    
    @State var searchUser: User?
    @State var searchProfileUrl: String = ""
    @State var buttonOnOff: Bool = false

    let searchCellID: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            NavigationLink {
                if let user = searchUser {
                    OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                         user: user)
                    .onAppear {
                        // 네비게이션 링크를 클릭했을 때 실행될 코드
                        searchVM.addSearchData(searchCellID)
                    }
                }
            } label: {
                HStack(spacing: 0) {
                    if let image = URL(string: searchProfileUrl) {
                        KFImage(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(40)
                            .padding(.trailing)
                    } else {
                        Image("defaultProfile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(40)
                            .padding(.trailing)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if let user = searchUser {
                            Text(user.nameID)
                                .foregroundStyle(.white)
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            
                            if !user.username.isEmpty {
                                Text(user.username)
                                    .font(.system(.subheadline))
                                    .fontWeight(.regular)
                                    .foregroundStyle(Color(.systemGray))
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            Button {
                // 유저디폴트값에서 삭제
                searchVM.removeSearchData(searchCellID)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(.body,
                                  weight: .medium))
                    .foregroundStyle(.gray)
                    .padding()
            }
        } //: HSTACK
        .padding(.horizontal)
        .task {
            let updateUserData = UpdateUserData()
            if let userProfile = await updateUserData.getOthersProfileDatas(id: searchCellID) {
                self.searchProfileUrl = userProfile.profileImageUrl ?? ""
                self.searchUser = userProfile
            }
            self.buttonOnOff = UpdateFollowData.shared.checkFollowingStatus(id: searchCellID)
        }
    }
}


