//
//  FollowingView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowingView: View {
    // MARK: - PROPERTY
    @EnvironmentObject var viewModel: MainViewModel
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var followVM: FollowViewModel
    
    @State private var searchText: String = ""
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.main.ignoresSafeArea()
            VStack {
                VStack {
                    SearchBar(text: $searchText,
                              isLoading: $followVM.isLoading)
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                    
                    if searchText.isEmpty {
                        ScrollView(.vertical) {
                            VStack {
                                HStack {
                                    Text("팔로잉")
                                        .font(.system(.subheadline, weight: .medium))
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
                                    NoItemView(itemName: "아직 팔로잉한 사람이 없습니다")
                                        .padding(.top, 150)
                                }
                            }
                            .padding(.bottom)
                        }
                    } else if followVM.viewState == .empty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.gray)
                            .font(.system(.body,
                                          weight: .semibold))
                            .padding(.top, 150)
                    } else {
                        ScrollView(.vertical) {
                            VStack {
                                HStack {
                                    Text("팔로잉")
                                        .font(.system(.subheadline, weight: .medium))
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
        .onChange(of: searchText) { _, _ in
            Task {
                await followVM.searchFollowers(with: searchText, type: SearchFollowType.following)
            }
        }
    }
}
