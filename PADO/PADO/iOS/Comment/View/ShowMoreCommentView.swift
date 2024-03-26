//
//  ShowMoreCommentView.swift
//  PADO
//
//  Created by 최동호 on 2/27/24.
//

import SwiftUI

struct ShowMoreCommentView: View {
    @ObservedObject var commentVM: CommentViewModel
    
    @State private var showReplyComment = "hide"

    @Binding var post: Post
    
    let index: Int
    
    var body: some View {
        switch showReplyComment {
        case "hide":
            Button {
                Task {
                    showReplyComment = "fetching"
                    await commentVM.getReplyCommentsDocument(post: post,
                                                             index: index)
                    showReplyComment = "show"
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
                        .font(.system(.caption, weight: .semibold))
                        .foregroundStyle(Color(.systemGray))
                    
                }
                .padding(.leading, 10)
                .padding(.vertical, 8)
            }
        case "show":
            ForEach(commentVM.comments[index].replyComments, id:\.self) { replyCommentID in
                ReplyCommentCell(commentVM: commentVM,
                                 post: $post,
                                 index: index,
                                 replyCommentID: replyCommentID)
            }
        default:
            HStack {
                Spacer()
                
                ProgressView()
                
                Spacer()
            }
        }
    }
}
