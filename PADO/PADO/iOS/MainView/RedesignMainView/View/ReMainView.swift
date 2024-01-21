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
    
    @State private var isHeaderVisible = true // 상태 변수 추가
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Pic3")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    if isHeaderVisible {
                        // MARK: - Header
                        MainHeaderCell()
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.leading, 4)
                    }
                    
                    Spacer()
                    
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
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .gesture(DragGesture().onEnded { value in
                if value.translation.height > 0 {
                    // 사용자가 위로 스와이프했을 때
                    isHeaderVisible = false
                } else if value.translation.height < 0 {
                    // 사용자가 아래로 스와이프했을 때
                    isHeaderVisible = true
                }
            })
        }
    }
}


#Preview {
    ReMainView()
}
