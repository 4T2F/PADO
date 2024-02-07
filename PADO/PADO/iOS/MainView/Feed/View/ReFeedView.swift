//
//  ReFeedView.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import SwiftUI

struct ReFeedView: View {
    @State private var isLoading = true
    @Binding var selectedFilter: FeedFilter
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var feedVM: FeedViewModel
    @StateObject var surfingVM: SurfingViewModel
    @StateObject var profileVM: ProfileViewModel
    @StateObject var followVM: FollowViewModel
    
    let updateHeartData = UpdateHeartData()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if authenticationViewModel.selectFilter == .following {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing:0) {
                            ForEach(feedVM.followingPosts.indices, id: \.self) { index in
                                FeedCell(feedVM: feedVM,
                                         surfingVM: surfingVM,
                                         profileVM: profileVM,
                                         updateHeartData: updateHeartData,
                                         post: feedVM.followingPosts[index])
                                .id(index)
                                .onAppear {
                                    if index == feedVM.followingPosts.count - 1{
                                        Task {
                                            await feedVM.fetchFollowMorePosts()
                                        }
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .padding(.bottom, 3)
                    .scrollTargetBehavior(.paging)
                    .ignoresSafeArea(.all, edges: .top)
                    .refreshable {
                        feedVM.findFollowingUsers()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing:0) {
                            ForEach(feedVM.todayPadoPosts.indices, id: \.self) { index in
                                FeedCell(feedVM: feedVM,
                                         surfingVM: surfingVM,
                                         profileVM: profileVM,
                                         updateHeartData: updateHeartData,
                                         post: feedVM.todayPadoPosts[index])
                                .id(index)
                                .onAppear {
                                    if index == feedVM.todayPadoPosts.count - 1{
                                        Task {
                                            await feedVM.fetchTodayPadoMorePosts()
                                        }
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .padding(.bottom, 3)
                    .scrollTargetBehavior(.paging)
                    .ignoresSafeArea(.all, edges: .top)
                    .onAppear {
                        Task {
                            await feedVM.fetchTodayPadoPosts()
                        }
                    }
                    .refreshable {
                        Task{
                            await feedVM.fetchTodayPadoPosts()
                        }
                    }
                }
                
                VStack {
                    FeedHeaderCell()
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
}
