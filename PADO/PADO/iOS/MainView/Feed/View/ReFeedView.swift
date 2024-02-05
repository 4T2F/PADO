//
//  ReFeedView.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import Kingfisher
import SwiftUI

struct ReFeedView: View {
    @State private var isLoading = true
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var feedVM: FeedViewModel
    @StateObject var surfingVM: SurfingViewModel
    @StateObject var profileVM: ProfileViewModel
    @StateObject var followVM: FollowViewModel
    
    @StateObject private var mainCommentVM = MainCommentViewModel()
    @StateObject private var mainFaceMojiVM = MainFaceMojiViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing:0) {
                        ForEach (0..<10) { post in
                            FeedCell(heartLoading: (post != 0),
                                     isShowingReportView: $feedVM.isShowingReportView,
                                     isShowingCommentView: $feedVM.isShowingCommentView,
                                     feedVM: feedVM,
                                     surfingVM: surfingVM,
                                     profileVM: profileVM,
                                     post: post)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                
                VStack {
                    VStack {
                        HStack(spacing: 14) {
                            Text("팔로잉")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            Text("오늘 파도")
                                .foregroundStyle(.gray)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
}
