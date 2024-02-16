//
//  FollowingView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowingView: View {
    // MARK: - PROPERTY
    @Environment (\.dismiss) var dismiss
    @State private var searchText: String = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var followVM: FollowViewModel
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return searchText
        } set: {
            searchText = $0
            followVM.searchFollowers(with: $0, type: SearchFollowType.following)
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
                            VStack {
                                HStack {
                                    Text("팔로잉")
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Spacer()
                                } //: HSTACK
                                .padding(.leading)
                                
                                if !followVM.followingIDs.isEmpty{
                                    LazyVStack(spacing: 8) {
                                        ForEach(followVM.followingIDs, id: \.self) { followingID in
                                            FollowingCellView(cellUserId: followingID)
                                                .padding(.vertical)
                                        }
                                    }
                                } else {
                                    NoItemView(itemName: "아직 팔로잉한 사람이 없어요")
                                        .padding(.top, 150)
                                }
                            }
                            .padding(.bottom)
                        }
                    } else if followVM.viewState == .empty {
                        Text("검색 결과가 없어요")
                            .foregroundColor(.gray)
                            .font(.system(size: 16,
                                          weight: .semibold))
                            .padding(.top, 150)
                    } else {
                        ScrollView(.vertical) {
                            VStack {
                                HStack {
                                    Text("팔로잉")
                                        .font(.system(size: 14, weight: .medium))
                                    
                                    Spacer()
                                } //: HSTACK
                                .padding(.leading)
                                
                                LazyVStack(spacing: 8) {
                                    ForEach(followVM.searchedFollowing, id: \.self) { followingID in
                                        FollowingCellView(cellUserId: followingID)
                                        .padding(.vertical)
                                    }
                                } //: SCROLL
                            }
                            .padding(.bottom)
                        }
                    }
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
        .onDisappear {
            Task {
                await UpdateFollowData.shared.fetchFollowStatusData()
            }
        }
    }
}
