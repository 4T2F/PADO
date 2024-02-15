//
//  ReFeedView.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import SwiftUI

struct FeedView: View {
    @State private var isLoading = true
    @Binding var selectedFilter: FeedFilter
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var notiVM: NotificationViewModel
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    
    let updateHeartData = UpdateHeartData()
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomRefreshView(showsIndicator: false,
                                  lottieFileName: "Wave",
                                  scrollDelegate: scrollDelegate) {
                    if selectedFilter == .following {
                        LazyVStack(spacing: 0) {
                            ForEach(feedVM.followingPosts.indices, id: \.self) { index in
                                FeedCell(feedVM: feedVM,
                                         surfingVM: surfingVM,
                                         profileVM: profileVM,
                                         updateHeartData: updateHeartData,
                                         post: $feedVM.followingPosts[index],
                                         isTodayPadoPost: false,
                                         todayPadoPostIndex: index)
                                .id(index)
                                .onAppear {
                                    if index == feedVM.followingPosts.count - 1{
                                        Task {
                                            await feedVM.fetchFollowMorePosts()
                                        }
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(feedVM.todayPadoPosts.indices, id: \.self) { index in
                                FeedCell(feedVM: feedVM,
                                         surfingVM: surfingVM,
                                         profileVM: profileVM,
                                         updateHeartData: updateHeartData,
                                         post: $feedVM.todayPadoPosts[index],
                                         isTodayPadoPost: true,
                                         todayPadoPostIndex: index)
                                .id(index)
                            }
                        }
                    }
                } onRefresh: {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    if selectedFilter == FeedFilter.following {
                        feedVM.findFollowingUsers()
                    } else {
                        Task{
                            await feedVM.fetchTodayPadoPosts()
                            await notiVM.fetchNotifications()
                        }
                    }
                }
                .scrollDisabled(feedVM.isShowingPadoRide)
                
                VStack {
                    if !feedVM.isShowingPadoRide {
                        if scrollDelegate.scrollOffset < 5 {
                            FeedHeaderCell(selectedFilter: $selectedFilter, notiVM: notiVM)
                                .transition(.opacity.combined(with: .scale))
                        } else if !scrollDelegate.isEligible {
                            FeedRefreshHeaderCell()
                                .transition(.opacity.combined(with: .scale))
                        }
                        Spacer()
                    }
                }
                .padding(.top, 10)
                .animation(.easeInOut, value: scrollDelegate.scrollOffset)
            }
        }
    }
}
