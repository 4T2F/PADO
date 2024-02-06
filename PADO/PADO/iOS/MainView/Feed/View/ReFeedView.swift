//
//  ReFeedView.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import SwiftUI

struct ReFeedView: View {
    @State private var isLoading = true
    @State private var selectedFilter: FeedFilter = .following
    
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
                        ScrollViewReader { value in
                            LazyVStack(spacing:0) {
                                ForEach(feedVM.followingPosts) { post in
                                    FeedCell(feedVM: feedVM,
                                             surfingVM: surfingVM,
                                             profileVM: profileVM,
                                             updateHeartData: updateHeartData,
                                             post: post)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .ignoresSafeArea()
                } else {
                    TestTodayView(feedVM: feedVM,
                                  surfingVM: surfingVM,
                                  profileVM: profileVM,
                                  followVM: followVM)
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
