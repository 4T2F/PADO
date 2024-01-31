//
//  ReMainView.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import Kingfisher
import SwiftUI

struct FeedView: View {
    
    @State private var isLoading = true
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var feedVM: FeedViewModel
    @StateObject var surfingVM: SurfingViewModel
    @StateObject private var mainCommentVM = MainCommentViewModel()
    @StateObject private var mainFaceMojiVM = MainFaceMojiViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let imageUrl = URL(string: feedVM.selectedPostImageUrl) {
                    ZStack {
                        KFImage.url(imageUrl)
                            .resizable()
                            .onSuccess { _ in
                                // 이미지 로딩 성공 시
                                isLoading = false
                            }
                            .onFailure { _ in
                                // 이미지 로딩 실패 시
                                isLoading = false
                            }
                            .onProgress { receivedSize, totalSize in
                                // 로딩 중
                                isLoading = true
                            }
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(height: UIScreen.main.bounds.height * 0.85)
                        
                        if isLoading { // feedVM에서 로딩 상태를 관리한다고 가정
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                
                if feedVM.isHeaderVisible {
                    LinearGradient(colors: [.black.opacity(0.5),
                                            .black.opacity(0.4),
                                            .black.opacity(0.4),
                                            .black.opacity(0.3),
                                            .black.opacity(0.2),
                                            .clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .black.opacity(0.2),
                                            .black.opacity(0.2),
                                            .black.opacity(0.2),
                                            .black.opacity(0.2),
                                            .black.opacity(0.3),
                                            .black.opacity(0.4)],
                                   startPoint: .bottom,
                                   endPoint: .top
                    )
                    .ignoresSafeArea()
                }
                
                VStack {
                    // MARK: - Header
                    if feedVM.isHeaderVisible {
                        MainHeaderCell(vm: feedVM)
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.leading, 4)
                            .padding(.top, 5)
                    }
                    
                    Spacer()
                    
                    // MARK: - HeartComment
                    HeartCommentCell(isShowingReportView: $feedVM.isShowingReportView, isShowingCommentView: $feedVM.isShowingCommentView, feedVM: feedVM, surfingVM: surfingVM)
                        .padding(.leading, UIScreen.main.bounds.width)
                        .padding(.trailing, 60)
                        .padding(.bottom, 10)
                    
                    // MARK: - Story
                    if feedVM.isHeaderVisible {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(feedVM.stories.enumerated()), id: \.element) { index, story in
                                    StoryCell(story: story,
                                              storyIndex: index,
                                              feedVM: feedVM) {
                                        Task {
                                            await self.feedVM.selectStory(story)
                                        }
                                    }
                                }
                                Button(action: {
                                    Task {
                                        feedVM.findFollowingUsers()
                                    }
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                        .padding()
                                        .background(Circle().fill(Color.gray))
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding()
                        .transition(.opacity)
                    }
                }
                .overlay {
                    if !feedVM.isHeaderVisible {
                        ZStack {
                            ForEach(mainCommentVM.mainComments.reversed()) { comment in
                                MainCommentCell(mainComment: comment)
                                    .position(comment.nameID == authenticationViewModel.currentUser?.nameID ?
                                              feedVM.textPosition :
                                                CGPoint(x: CGFloat(comment.commentPositionsX),
                                                        y: CGFloat(comment.commentPositionsY)))
                                    .gesture(
                                        DragGesture()
                                            .onChanged(feedVM.handleDragGestureChange)
                                            .onEnded { _ in feedVM.handleDragGestureEnd() }
                                    )
                            }
                            ForEach(mainFaceMojiVM.mainFaceMoji.reversed()) { faceMoji in
                                MainFaceMojiCell(mainFaceMoji: faceMoji)
                                    .position(faceMoji.nameID == authenticationViewModel.currentUser?.nameID ?
                                              feedVM.faceMojiPosition :
                                                CGPoint(x: CGFloat(faceMoji.faceMojiPositionsX),
                                                        y: CGFloat(faceMoji.faceMojiPositionsY)))
                                    .gesture(
                                        DragGesture()
                                            .onChanged(feedVM.handleFaceMojiDragChange)
                                            .onEnded { _ in feedVM.handleFaceMojiDragEnd() }
                                    )
                            }
                        }
                    }
                }
            }
            .gesture(DragGesture().onEnded(feedVM.toggleHeaderVisibility))
        }
        
    }
}
