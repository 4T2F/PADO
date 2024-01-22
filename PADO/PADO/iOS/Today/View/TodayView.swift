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
    
    @State private var isCellVisible = true
    
    @State private var isCommentVisible = false
    @StateObject private var commentVM = CommentViewModel()
    @StateObject private var mainCommentVM = MainCommentViewModel()
    
    @State private var textPosition = CGPoint(x: 300, y: 300)
    @State private var dragStart: CGPoint?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("myunghyun")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    if isCellVisible {
                        HStack {
                            TodayCell()
                                .padding(.top, 80)
                            
                            Spacer()
                            
                            //MARK: - HeartComment
                            HeartCommentCell(isShowingReportView: $isShowingReportView, isShowingCommentView: $isShowingCommentView)
                                .padding(.trailing, 12)
                                .padding(.top, 5)
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
                
            }
            .overlay {
                if !isCellVisible {
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
                    }
            )
        }
    }
}

#Preview {
    TodayView()
}
