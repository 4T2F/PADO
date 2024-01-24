//
//  ReMainView.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct FeedView: View {
    @State private var isShowingReportView = false
    @State private var isShowingCommentView = false
    
    // false 이면 MainHeaderCell과 story 사라지면서 댓글이 나타남
    @State private var isHeaderVisible = true
    let dragThreshold: CGFloat = 0
    
    @State private var isCommentVisible = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    // 댓글 commentVM
    @StateObject private var commentVM = CommentViewModel()
    // 화면에 띄워질 commentVM
    @StateObject private var mainCommentVM = MainCommentViewModel()
    @StateObject private var mainFaceMojiVM = MainFaceMojiViewModel()
    
    @State private var textPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var faceMojiPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var dragStart: CGPoint?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Pic3")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    // MARK: - Header
                    if isHeaderVisible {
                        MainHeaderCell()
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.leading, 4)
                    }
                    
                    Spacer()
                    
                    //MARK: - HeartComment
                    HeartCommentCell(isShowingReportView: $isShowingReportView, isShowingCommentView: $isShowingCommentView)
                        .padding(.leading, UIScreen.main.bounds.width)
                        .padding(.trailing, 60)
                        .padding(.bottom, 10)
                    
                    // MARK: - Story
                    if isHeaderVisible {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<storyData.count, id: \.self) { cell in
                                    StoryCell(story: storyData[cell])
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding()
                        .transition(.opacity)
                    }
                }
                // 아래 제스쳐 했을 때 화면에 댓글을 오버레이로 띄워줌
                .overlay {
                    if !isHeaderVisible {
                        ZStack {
                            ForEach(mainCommentVM.mainComments.reversed()) { comment in
                                if viewModel.currentUser?.nameID == comment.nameID {
                                    MainCommentCell(mainComment: comment)
                                        .position(textPosition)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    if dragStart == nil {
                                                        dragStart = gesture.startLocation
                                                    }
                                                    let dragAmount = CGPoint(x: gesture.translation.width, y: gesture.translation.height)
                                                    let initialPosition = dragStart ?? CGPoint.zero
                                                    self.textPosition = CGPoint(x: initialPosition.x + dragAmount.x, y: initialPosition.y + dragAmount.y)
                                                }
                                                .onEnded { _ in
                                                    dragStart = nil
                                                }
                                        )
                                } else {
                                    MainCommentCell(mainComment: comment)
                                        .position(CGPoint(x: CGFloat(comment.commentPositionsX), y: CGFloat(comment.commentPositionsY)))
                                }
                            }
                            
                            ForEach(mainFaceMojiVM.mainFaceMoji.reversed()) { faceMoji in
                                if viewModel.currentUser?.nameID == faceMoji.nameID {
                                    MainFaceMojiCell(mainFaceMoji: faceMoji)
                                        .position(faceMojiPosition)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    if dragStart == nil {
                                                        dragStart = gesture.startLocation
                                                    }
                                                    let dragAmount = CGPoint(x: gesture.translation.width, y: gesture.translation.height)
                                                    let initialPosition = dragStart ?? CGPoint.zero
                                                    self.faceMojiPosition = CGPoint(x: initialPosition.x + dragAmount.x, y: initialPosition.y + dragAmount.y)
                                                }
                                                .onEnded { _ in
                                                    dragStart = nil
                                                }
                                        )
                                } else {
                                    MainFaceMojiCell(mainFaceMoji: faceMoji)
                                        .position(CGPoint(x: CGFloat(faceMoji.faceMojiPositionsX), y: CGFloat(faceMoji.faceMojiPositionsY)))
                                }
                            }
                            
                        }
                    }
                }
            }
            // 위아래 제스쳐 로직
            .gesture(DragGesture().onEnded { value in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if value.translation.height > dragThreshold {
                        // 사용자가 아래로 충분히 스와이프했을 때
                        isHeaderVisible = false
                    } else if -value.translation.height > dragThreshold {
                        // 사용자가 위로 충분히 스와이프했을 때
                        isHeaderVisible = true
                    }
                }
            })
        }
    }
}

//
//#Preview {
//    FeedView()
//}
