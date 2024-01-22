//
//  ReMainView.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct ReMainView: View {
    @State private var isShowingReportView = false
    @State private var isShowingCommentView = false
    
    @State private var isHeaderVisible = true
    let dragThreshold: CGFloat = 0
    
    @State private var isCommentVisible = false
    @StateObject private var commentVM = CommentViewModel()
    @StateObject private var mainCommentVM = MainCommentViewModel()
    
    @State private var textPosition = CGPoint(x: 300, y: 300)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if !isHeaderVisible {
                        VStack {
                            ForEach(mainCommentVM.mainComments) { comment in
                                        MainCommentCell(mainComment: comment)
                            }
                        }
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
                    }
                }
            }
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


#Preview {
    ReMainView()
}
