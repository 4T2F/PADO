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
    @State var searchUser: User?
    @State var searchProfileUrl: String = ""
    @State var buttonOnOff: Bool = false
    
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var searchVM: SearchViewModel

    let searchCellID: String
    let updateFollowData: UpdateFollowData

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    if let user = searchUser {
                        OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                             updateFollowData: updateFollowData,
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
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                                .padding(.trailing)
                        } else {
                            Image("defaultProfile")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                                .padding(.trailing)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            if let user = searchUser {
                                Text(user.nameID)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                if !user.username.isEmpty {
                                    Text(user.username)
                                        .font(.system(size: 12))
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
                        .font(.system(size: 16,
                                      weight: .medium))
                        .foregroundStyle(.gray)
                        .padding()
                }
            } //: HSTACK
            .padding(.horizontal)
        }//: NAVI
        .onAppear {
            Task {
                let updateUserData = UpdateUserData()
                if let userProfile = await updateUserData.getOthersProfileDatas(id: searchCellID) {
                    self.searchProfileUrl = userProfile.profileImageUrl ?? ""
                    self.searchUser = userProfile
                }
                self.buttonOnOff = await updateFollowData.checkFollowStatus(id: searchCellID)
            }
        }
    }
}


