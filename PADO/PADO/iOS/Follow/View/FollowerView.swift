//
//  FollowerView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowerView: View {
    // MARK: - PROPERTY
    @Environment (\.dismiss) var dismiss
    @State private var searchText: String = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var followVM: FollowViewModel
    
    let updateFollowData: UpdateFollowData
    
    let user: User
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return searchText
        } set: {
            searchText = $0
            followVM.updateSearchText(with: $0)
        }
        
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                VStack {
                    SearchBar(text: searchTextBinding,
                              isLoading: $followVM.isLoading)
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                    
                    ScrollView(.vertical) {
                        if !followVM.surferIDs.isEmpty {
                            VStack {
                                HStack {
                                    Text("서퍼")
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Spacer()
                                } //: HSTACK
                                .padding(.leading)
                                
                                LazyVStack(spacing: 8) {
                                    ForEach(followVM.surferIDs, id: \.self) { surferId in
                                        if user.nameID == userNameID {
                                            FollowerUserCellView(followVM: followVM, cellUserId: surferId, sufferset: .removesuffer)
                                                .padding(.vertical)
                                        } else {
                                            FollowerOtherUserCellView(followVM: followVM, cellUserId: surferId, updateFollowData: updateFollowData)
                                                .padding(.vertical)
                                        }
                                    }
                                }
                                
                                Divider()
                                    .padding(.horizontal)
                                    .padding(.top, 5)
                            }
                            .padding(.bottom)
                        }
                        
                        VStack {
                            HStack {
                                Text("팔로워")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                            } //: HSTACK
                            .padding(.leading)
                            
                            LazyVStack(spacing: 8) {
                                ForEach(followVM.followerIDs, id: \.self) { followerId in
                                    if user.nameID == userNameID {
                                    FollowerUserCellView(followVM: followVM, cellUserId: followerId, sufferset: .setsuffer)
                                        .padding(.vertical)
                                    } else {
                                        FollowerOtherUserCellView(followVM: followVM, cellUserId: followerId, updateFollowData: updateFollowData)
                                            .padding(.vertical)
                                    }
                                }
                            }
                        } //: SCROLL
                    }
                    .padding(.bottom)
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
    }
}
