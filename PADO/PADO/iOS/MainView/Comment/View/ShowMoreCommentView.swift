//
//  ShowMoreCommentView.swift
//  PADO
//
//  Created by 최동호 on 2/27/24.
//

import SwiftUI

struct ShowMoreCommentView: View {
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State private var showReplyComment: Bool = false
    @Binding var post: Post
    let index: Int
    
    var body: some View {
        switch showReplyComment {
        case false:
            Button {
                Task {
                    await commentVM.getReplyCommentsDocument(post: post,
                                                             index: index)
                    showReplyComment = true
                }
            } label: {
                HStack {
                    Rectangle()
                        .frame(width: 38, height: 1)
                        .foregroundStyle(.clear)
                    
                    Rectangle()
                        .frame(width: 20, height: 0.5)
                        .foregroundStyle(Color(.systemGray))
                    
                    Text("답글 \(commentVM.comments[index].replyComments.count)개 보기")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(.systemGray))
                    
                }
                .padding(.leading, 10)
                .padding(.vertical, 8)
            }
        case true:
            ForEach(commentVM.comments[index].replyComments, id:\.self) { replyCommentID in
                ReplyCommentCell(index: index,
                                 replyCommentID: replyCommentID,
                                 commentVM: commentVM,
                                 post: $post)
            }

        }
    }
}
