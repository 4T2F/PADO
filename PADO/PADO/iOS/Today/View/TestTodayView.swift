//
//  TestTodayVIew.swift
//  PADO
//
//  Created by 황성진 on 2/6/24.
//
//
//  Today.swift
//  PADO
//
//  Created by 강치우 on 1/25/24.
//

import SwiftUI

struct TestTodayView: View {
    @State private var isShowingReportView = false
    @State private var isShowingCommentView = false
    
    @State private var isCellVisible = true
    @State private var isCommentVisible = false
    
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    
    let updateHeartData = UpdateHeartData()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing:0) {
                        ForEach(feedVM.followingPosts) { post in
                            TodayCell(feedVM: feedVM,
                                      surfingVM: surfingVM,
                                      profileVM: profileVM,
                                      updateHeartData: updateHeartData,
                                      post: post)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
            }
        }
    }
}
