//
//  CommentCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct CommentCell: View {
    let comment: Comment
    var showDetails: Bool = true

    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .fill(Color.gray)
                .frame(width: 35, height: 35)
                .overlay(
                    Text(comment.username.prefix(1))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )
                .padding(.trailing, 6)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.username)
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                        .padding(.trailing, 4)
                    
                    if showDetails {
                        Text(comment.time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button {
                            // 버튼 액션
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Text(comment.comment)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    CommentCell(comment: Comment(username: "dearkang", comment: "하하하 너무재밌네요", time: "1분 전"))
}
