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
    let dragThreshold: CGFloat = 80
    
    @State private var isCommentVisible = false
    @StateObject private var commentVM = CommentViewModel()
    
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
                    
                    if !isHeaderVisible {
                        ForEach(commentVM.comments) { comment in
                            CommentCell(comment: comment, showDetails: false)
                        }
                    }
                    
                    //MARK: - HeartComment
                    HeartCommentCell(isShowingReportView: $isShowingReportView, isShowingCommentView: $isShowingCommentView)
                        .padding(.leading, UIScreen.main.bounds.width)
                        .padding(.trailing, 55)
                        .padding(.top)
                    
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
