//
//  ReFeedView.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import Lottie
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @StateObject var notiVM = NotificationViewModel.shared
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { proxy in
                    CustomRefreshView(showsIndicator: false,
                                      lottieFileName: "Wave",
                                      scrollDelegate: scrollDelegate) {
                        if viewModel.selectedFilter == .following {
                            LazyVStack(spacing: 0) {
                                if feedVM.postFetchLoading {
                                    LottieView(animation: .named("Loading"))
                                        .looping()
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .containerRelativeFrame([.horizontal,.vertical])
                                } else if feedVM.followFetchLoading {
                                    EmptyView()
                                } else if feedVM.followingPosts.isEmpty {
                                    FeedGuideView(title: "인기 팔로워",
                                                  content: "계정을 팔로우하여 최신 게시물을\n여기서 확인하세요.",
                                                  popularUsers: feedVM.popularUsers)
                                        .containerRelativeFrame([.horizontal,.vertical])
                                } else {
                                    ForEach(feedVM.followingPosts.indices, id: \.self) { index in
                                        FeedCell(feedVM: feedVM,
                                                 post: $feedVM.followingPosts[index], feedCellType: FeedFilter.following,
                                                 index: index)
                                        .id(index)
                                        .onAppear {
                                            if index == feedVM.followingPosts.indices.last {
                                                Task {
                                                    await feedVM.fetchFollowMorePosts()
                                                }
                                            }
                                        }
                                    }
                                    .scrollTargetLayout()
                                }
                            }
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(feedVM.todayPadoPosts.indices, id: \.self) { index in
                                    FeedCell(feedVM: feedVM,
                                             post: $feedVM.todayPadoPosts[index], 
                                             feedCellType: FeedFilter.today,
                                             index: index)
                                }
                            }
                        }
                    } onRefresh: {
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        if viewModel.selectedFilter == FeedFilter.following {
                            guard !userNameID.isEmpty else {
                                await feedVM.getPopularUser()
                                feedVM.stopFollowingListeners()
                                profileVM.stopAllPostListeners()
                                feedVM.followingPosts.removeAll()
                                return
                            }
                            await profileVM.fetchBlockUsers()
                            await followVM.initializeFollowFetch(id: userNameID)
                            feedVM.followFetchLoading = true
                            feedVM.stopFollowingListeners()
                            profileVM.stopAllPostListeners()
                            await feedVM.fetchFollowingPosts()
                            await profileVM.fetchPostID(user: viewModel.currentUser!)
                            await notiVM.fetchNotifications()
                            feedVM.followFetchLoading = false
                        } else {
                            Task{
                                await profileVM.fetchBlockUsers()
                                feedVM.stopTodayListeners()
                                await feedVM.fetchTodayPadoPosts()
                                guard !userNameID.isEmpty else { return }
                                await followVM.initializeFollowFetch(id: userNameID)
                                await profileVM.fetchPostID(user: viewModel.currentUser!)
                                await notiVM.fetchNotifications()
                            }
                        }
                    }
                    .scrollDisabled(feedVM.isShowingPadoRide)
                    .onChange(of: viewModel.scrollToTop) {
                        withAnimation {
                            feedVM.currentPadoRideIndex = nil
                            feedVM.isHeaderVisible = true
                            feedVM.isShowingPadoRide = false
                            feedVM.padoRidePosts = []
                            proxy.scrollTo(0, anchor: .top)
                        }
                    }
                    .onChange(of: viewModel.selectedFilter) {
                        withAnimation {
                            proxy.scrollTo(0, anchor: .top)
                        }
                    }
                }
                VStack {
                    if !feedVM.isShowingPadoRide {
                        if scrollDelegate.scrollOffset < 5 {
                            FeedHeaderCell(feedVM: feedVM)
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
