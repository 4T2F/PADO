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
            Circle()
                .fill(Color.gray)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(comment.username.prefix(1))
                        .bold()
                        .foregroundColor(.white)
                )
                .padding(.trailing, 6)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.username)
                        .fontWeight(.semibold)
                        .padding(.trailing, 4)
                   
                    Text(comment.time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.bottom, 4)
                
                Text(comment.comment)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
                
                Button {
                    // 답장
                } label: {
                    Text("답장")
                        .font(.system(size: 14))
                        .foregroundStyle(.grayButton)
                }
            }
        }

    }
}

//#Preview {
//    CommentCell()
//}
