//
//  MainCommentCell.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct MainCommentCell: View {
    let mainComment: MainComment
    
    @State private var isDragging = false
    
    var body: some View {
        HStack {
            // 유저의 프로필 사진 받아와야함 프로필 사진이 없으면 기본 프사로 적용되게 해야함
            Circle()
                .fill(Color.gray)
                .frame(width: 30, height: 30)
                .overlay(
                    Text(mainComment.nameID.prefix(1))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )
            // 댓글 받아와야함
            Text(mainComment.comment)
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
        .scaleEffect(isDragging ? 1.1 : 1.0) // 드래그 중이면 크기를 1.1로, 아니면 1.0으로 설정
        .gesture(
            DragGesture()
                .onChanged { _ in
                    isDragging = true
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
        .animation(.easeInOut, value: isDragging) // 드래그 상태 변화에 따른 애니메이션 적용
        
    }
}

// #Preview {
//     MainCommentCell(mainComment: MainComment(nameID: "dearkang", comment: "하하하 너무재밌네요"))
// }
