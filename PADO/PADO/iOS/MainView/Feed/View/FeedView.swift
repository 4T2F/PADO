//
//  ReFeedView.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import SwiftUI

struct FeedView: View {
    @State private var isLoading = true
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var notiVM: NotificationViewModel
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomRefreshView(showsIndicator: false,
                                  lottieFileName: "Wave",
                                  scrollDelegate: scrollDelegate) {
                    if authenticationViewModel.selectedFilter == .following {
                        ScrollViewReader { value in
                            LazyVStack(spacing: 0) {
                                ForEach(feedVM.followingPosts.indices, id: \.self) { index in
                                    FeedCell(feedVM: feedVM,
                                             surfingVM: surfingVM,
                                             profileVM: profileVM,
                                             feedCellType: FeedFilter.following,
                                             post: $feedVM.followingPosts[index],
                                             index: index)
                                    .id(index)
                                    
                                    if index == feedVM.feedItems.indices.last {
                                        Color.clear
                                            .onAppear {
                                                // 스크롤 뷰의 끝에 도달했을 때 실행될 코드
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
                                         surfingVM: surfingVM,
                                         profileVM: profileVM,
                                         feedCellType: FeedFilter.today,
                                         post: $feedVM.todayPadoPosts[index],
                                         index: index)
                                .id(index)
                            }
                        }
                    }
                } onRefresh: {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    if authenticationViewModel.selectedFilter == FeedFilter.following {
                        await profileVM.fetchBlockUsers()
                        await followVM.fetchIDs(id: userNameID, collectionType: CollectionType.following)
                        await feedVM.fetchFollowingPosts()
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
                            FeedHeaderCell(notiVM: notiVM)
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
