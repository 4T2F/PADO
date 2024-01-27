//
//  TodayCommentCell.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct TodayCommentCell: View {
    let mainComment: MainComment
    
    var body: some View {
        HStack {
            // 유저 프로필 받아와야함, 프로필 사진이 없으면 기본 프사로 설정
            Circle()
                .fill(Color.gray)
                .frame(width: 30, height: 30)
                .overlay(
                    Text(mainComment.nameID.prefix(1))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )
            // 댓글 연동 시켜야함
            Text(mainComment.comment)
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
    }
}

// #Preview {
//    TodayCommentCell(mainComment: MainComment(nameID: "dearkang", comment: "하하하 너무재밌네요"))
// }
