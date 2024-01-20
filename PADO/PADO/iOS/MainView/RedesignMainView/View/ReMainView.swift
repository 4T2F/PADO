//
//  ReMainView.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct ReMainView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Pic3")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    // MARK: - Header
                    MainHeaderCell()
                        .padding(.leading, 5)
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    // MARK: - HeartComment
                    HeartCommentCell()
                        .padding(.leading, geometry.size.width / 2.5) // 예를 들어 부모 뷰의 너비를 기준으로 패딩 조정
                        .padding(.top)
                    
                    // MARK: - Story
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<storyData.count, id: \.self) { cell in
                                StoryCell(story: storyData[cell])
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: UIScreen.main.bounds.width)
//                    .frame(width: geometry.size.width) // 부모 뷰의 너비를 사용
//                    .padding()
                }
            }
        }
    }
}

#Preview {
    ReMainView()
}
