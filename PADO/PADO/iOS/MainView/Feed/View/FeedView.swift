//
//  ReMainView.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject private var feedVM = FeedViewModel()
    
    @StateObject private var commentVM = CommentViewModel()
    @StateObject private var mainCommentVM = MainCommentViewModel()
    @StateObject private var mainFaceMojiVM = MainFaceMojiViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(feedVM.selectedStoryImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .id(feedVM.selectedStoryImage) // 뷰 갱신 강제화
                
                if feedVM.isHeaderVisible {
                    LinearGradient(colors: [.clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .clear, .clear,
                                            .black.opacity(0.1),
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
                        MainHeaderCell()
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.leading, 4)
                    }
                    
                    Spacer()
                    
                    // MARK: - HeartComment
                    HeartCommentCell(isShowingReportView: $feedVM.isShowingReportView, isShowingCommentView: $feedVM.isShowingCommentView)
                        .padding(.leading, UIScreen.main.bounds.width)
                        .padding(.trailing, 60)
                        .padding(.bottom, 10)
                    
                    // MARK: - Story
                    if feedVM.isHeaderVisible {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<storyData.count, id: \.self) { cell in
                                    StoryCell(story: storyData[cell]) {
                                        self.feedVM.selectStory(storyData[cell])
                                    }
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
                                    .position(comment.nameID == authenticationViewModel.currentUser?.nameID ? feedVM.textPosition : CGPoint(x: CGFloat(comment.commentPositionsX), y: CGFloat(comment.commentPositionsY)))
                                    .gesture(
                                        DragGesture()
                                            .onChanged(feedVM.handleDragGestureChange)
                                            .onEnded { _ in feedVM.handleDragGestureEnd() }
                                    )
                            }
                            
                            ForEach(mainFaceMojiVM.mainFaceMoji.reversed()) { faceMoji in
                                MainFaceMojiCell(mainFaceMoji: faceMoji)
                                    .position(faceMoji.nameID == authenticationViewModel.currentUser?.nameID ? feedVM.faceMojiPosition : CGPoint(x: CGFloat(faceMoji.faceMojiPositionsX), y: CGFloat(faceMoji.faceMojiPositionsY)))
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


#Preview {
    FeedView()
}
