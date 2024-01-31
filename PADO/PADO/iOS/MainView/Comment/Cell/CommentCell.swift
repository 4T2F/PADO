//
//  CommentCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top) {
            Image("defaultProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .padding(.trailing, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.userID)
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                        .padding(.trailing, 4)
                    Text(TimestampDateFormatter.formatDate(comment.time))
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
                
                Text(comment.content)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
            }
        }
    }
}
