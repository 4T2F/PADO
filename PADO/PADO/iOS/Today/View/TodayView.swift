//
//  TodayView.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct TodayView: View {
    @State private var isShowingReportView = false
    @State private var isShowingCommentView = false
    
    // false이면 TodayCell 사라짐
    @State private var isCellVisible = true
    
    @State private var isCommentVisible = false
    
    @StateObject private var commentVM = CommentViewModel()
    @StateObject private var mainCommentVM = MainCommentViewModel()
    
    @State private var textPosition = CGPoint(x: 300, y: 300)
    @State private var dragStart: CGPoint?
    
    var body: some View {
        NavigationStack {
            // 스크롤 추가해야함 인스타 릴스처럼 전환되게
            ZStack {
                Image("myunghyun")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    if isCellVisible {
                        HStack {
                            // MARK: - TodayCell
                            TodayCell()
                                .padding(.top, 80)
                            
                            Spacer()
                            
                            // MARK: - HeartComment
                            // 하트를 누른 상태에서 longpress제스쳐를 하고 난 후 하트가 off 돼있음 수정해야함
                            HeartCommentCell(isShowingReportView: $isShowingReportView, isShowingCommentView: $isShowingCommentView)
                                .padding(.trailing, 12)
                                .padding(.top, 5)
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
                
            }
            // isCellVisible이 false이면 화면에 댓글을 띄워줌
            .overlay {
                if !isCellVisible {
                    VStack {
                        ForEach(mainCommentVM.mainComments) { comment in
                            MainCommentCell(mainComment: comment)
                        }
                    }
                    // 초기 textPosition 값
                    .position(textPosition)
                    // 댓글 움직이게 하는 제스쳐 로직
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
                            })
                }
            }
            // 꾹 누르면 사라지고 다시 터치하면 나타나는 LongPressGesture 로직
            .gesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onChanged { _ in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isCellVisible = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isCellVisible = false
                        }
                    })
        }
    }
}

#Preview {
    TodayView()
}
