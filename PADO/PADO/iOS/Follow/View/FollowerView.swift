//
//  FollowerView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

enum FollowerModalType {
    case surfer
    case follower
}

struct FollowerView: View {
    // MARK: - PROPERTY
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @ObservedObject var followVM: FollowViewModel
    
    @State private var searchText: String = ""
    
    let user: User
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return searchText
        } set: {
            searchText = $0
            followVM.searchFollowers(with: $0, type: SearchFollowType.follower)
        }
        ZStack {
            Color.main.ignoresSafeArea()
            VStack {
                VStack {
                    SearchBar(text: searchTextBinding,
                              isLoading: $followVM.isLoading)
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                    if searchText.isEmpty {
                        ScrollView(.vertical) {
                            if !followVM.surferIDs.isEmpty {
                                VStack {
                                    HStack {
                                        Text("서퍼")
                                            .font(.system(.subheadline, weight: .medium))
                                        
                                        Spacer()
                                    } //: HSTACK
                                    .padding(.leading)
                                    
                                    LazyVStack(spacing: 8) {
                                        ForEach(followVM.surferIDs, id: \.self) { surferId in
                                            if user.nameID == userNameID {
                                                FollowerUserCellView(followVM: followVM,
                                                                     cellUserId: surferId,
                                                                     followerType: FollowerModalType.surfer,
                                                                     sufferset: .removesuffer)
                                                .padding(.vertical)
                                            } else {
                                                FollowerOtherUserCellView(followVM: followVM,
                                                                          cellUserId: surferId)
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
                                        .font(.system(.subheadline, weight: .medium))
                                    
                                    Spacer()
                                } //: HSTACK
                                .padding(.leading)
                                
                                if !followVM.followerIDs.isEmpty {
                                    LazyVStack(spacing: 8) {
                                        ForEach(followVM.followerIDs, id: \.self) { followerId in
                                            if user.nameID == userNameID {
                                                FollowerUserCellView(followVM: followVM,
                                                                     cellUserId: followerId,
                                                                     followerType: FollowerModalType.follower,
                                                                     sufferset: .setsuffer)
                                                .padding(.vertical)
                                            } else {
                                                FollowerOtherUserCellView(followVM: followVM, cellUserId: followerId)
                                                    .padding(.vertical)
                                            }
                                        }
                                    }
                                } else if followVM.surferIDs.isEmpty && followVM.followerIDs.isEmpty {
                                    NoItemView(itemName: "아직 팔로워가 없어요")
                                        .padding(.top, 150)
                                }
                            } //: SCROLL
                        }
                        .padding(.bottom)
                    } else if followVM.viewState == .empty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.gray)
                            .font(.system(.body,
                                          weight: .semibold))
                            .padding(.top, 150)
                    } else if followVM.viewState == .ready {
                        ScrollView(.vertical) {
                            if !followVM.surferIDs.isEmpty {
                                VStack {
                                    HStack {
                                        Text("서퍼")
                                            .font(.system(.subheadline, weight: .medium))
                                        
                                        Spacer()
                                    } //: HSTACK
                                    .padding(.leading)
                                    
                                    LazyVStack(spacing: 8) {
                                        ForEach(followVM.searchedSurfer, id: \.self) { surferId in
                                            if user.nameID == userNameID {
                                                FollowerUserCellView(followVM: followVM,
                                                                     cellUserId: surferId,
                                                                     followerType: FollowerModalType.surfer,
                                                                     sufferset: .removesuffer)
                                                .padding(.vertical)
                                            } else {
                                                FollowerOtherUserCellView(followVM: followVM, cellUserId: surferId)
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
                                        .font(.system(.subheadline, weight: .medium))
                                    
                                    Spacer()
                                } //: HSTACK
                                .padding(.leading)
                                
                                LazyVStack(spacing: 8) {
                                    ForEach(followVM.searchedFollower, id: \.self) { followerId in
                                        if user.nameID == userNameID {
                                            FollowerUserCellView(followVM: followVM,
                                                                 cellUserId: followerId,
                                                                 followerType: FollowerModalType.follower,
                                                                 sufferset: .setsuffer)
                                            .padding(.vertical)
                                        } else {
                                            FollowerOtherUserCellView(followVM: followVM, cellUserId: followerId)
                                                .padding(.vertical)
                                        }
                                    }
                                }
                            } //: SCROLL
                        }
                        .padding(.bottom)
                    }
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
    }
}
