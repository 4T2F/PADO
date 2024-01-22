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
            Circle()
                .fill(Color.gray)
                .frame(width: 30, height: 30)
                .overlay(
                    Text(mainComment.username.prefix(1))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )
            
            Text(mainComment.comment)
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    TodayCommentCell(mainComment: MainComment(username: "dearkang", comment: "하하하 너무재밌네요"))
}
