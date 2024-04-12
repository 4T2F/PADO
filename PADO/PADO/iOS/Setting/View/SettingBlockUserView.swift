//
//  SettingBlockUser.swift
//  PADO
//
//  Created by 강치우 on 2/16/24.
//

import Kingfisher

import SwiftUI

struct SettingBlockUserView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if profileVM.blockUser.isEmpty {
                    ZStack {
                        NoItemView(itemName: "차단목록이 없어요.")
                            .padding(.bottom, 250)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                } else {
                    ForEach(profileVM.blockUser) { user in
                        HStack {
                            KFImage(URL(string: user.blockUserProfileImage ))
                                .fade(duration: 0.5)
                                .placeholder {
                                    Image("defaultProfile")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 35, height: 35)
                                        .clipShape(Circle())
                                        .foregroundStyle(Color(.systemGray4))
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .padding(.trailing, 5)
                            Text(user.blockUserID)
                                .foregroundStyle(.white)
                                .font(.system(.title3, weight: .semibold))
                            
                            Spacer()
                            
                            Button {
                                Task {
                                    if let blockUser = await  UpdateUserData.shared.getOthersProfileDatas(id: user.blockUserID) {
                                        if let user = viewModel.currentUser {
                                            await profileVM.unblockUser(blockingUser: blockUser, user: user)
                                        }
                                    }
                                    await profileVM.fetchBlockUsers()
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white, lineWidth: 1)
                                        .frame(width: 80, height: 28)
                                    Text("차단 해제")
                                        .font(.system(.footnote))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                            }
                            
                        }
                    }
                    .padding(15)
                }
            }
        }
        .task {
            await profileVM.fetchBlockUsers()

        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("차단 목록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(.body))
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
}
