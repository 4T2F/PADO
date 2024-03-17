//
//  deleteCommentView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import SwiftUI

struct DeleteCommentView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    @Binding var post: Post
    
    let commentType: CommentType
    let index: Int?
    
    var body: some View {
        switch commentType {
        case .comment:
            VStack {
                VStack(alignment: .center) {
                    VStack(spacing: 10) {
                        if let user = viewModel.currentUser {
                            CircularImageView(size: .medium, user: user)
                        }
                        
                        Text("댓글을 정말 삭제하시겠습니까?")
                            .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(Color.white)
                    .font(.system(.subheadline))
                    .fontWeight(.medium)
                    .padding()
                    
                    Divider()
                    
                    Button {
                        if let selectComment = commentVM.selectedComment {
                            Task {
                                await commentVM.deleteComment(post: post,
                                                              commentID: selectComment.userID+(selectComment.time.convertTimestampToString(timestamp: selectComment.time)))
                                
                                commentVM.showDeleteModal = false
                            }
                        }
                        commentVM.showDeleteModal = false
                    } label: {
                        Text("댓글 삭제")
                            .font(.system(.body))
                            .foregroundStyle(Color.red)
                            .fontWeight(.semibold)
                            .frame(width: width * 0.9, height: 40)
                    }
                    .padding(.bottom, 5)
                    
                }
                .frame(width: width * 0.9)
                .background(Color.modal)
                .clipShape(.rect(cornerRadius: 22))
                
                VStack {
                    Button {
                        commentVM.showDeleteModal = false
                    } label: {
                        Text("취소")
                            .font(.system(.body))
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                            .frame(width: width * 0.9, height: 40)
                    }
                }
                .frame(width: width * 0.9, height: 50)
                .background(Color.modal)
                .clipShape(.rect(cornerRadius: 12))
            }
            .background(ClearBackground())
        case .replyComment:
            VStack {
                VStack(alignment: .center) {
                    VStack(spacing: 10) {
                        if let user = viewModel.currentUser {
                            CircularImageView(size: .medium, user: user)
                        }
                        
                        Text("답글을 정말 삭제하시겠습니까?")
                            .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(Color.white)
                    .font(.system(.subheadline))
                    .fontWeight(.medium)
                    .padding()
                    
                    Divider()
                    
                    Button {
                        if let replyComment = commentVM.selectedReplyComment,
                           let index = index,
                           let replyCommentID = replyComment.id {
                            Task {
                                await commentVM.deleteReplyComment(post: post,
                                                                   index: index,
                                                                   replyCommentID: replyCommentID)
                                
                                commentVM.showDeleteReplyModal = false
                            }
                        }
                        commentVM.showDeleteReplyModal = false
                    } label: {
                        Text("답글 삭제")
                            .font(.system(.body))
                            .foregroundStyle(Color.red)
                            .fontWeight(.semibold)
                            .frame(width: width * 0.9, height: 40)
                    }
                    .padding(.bottom, 5)
                    
                }
                .frame(width: width * 0.9)
                .background(Color.modal)
                .clipShape(.rect(cornerRadius: 22))
                
                VStack {
                    Button {
                        commentVM.showDeleteReplyModal = false
                    } label: {
                        Text("취소")
                            .font(.system(.body))
                            .foregroundStyle(Color.white)
                            .fontWeight(.semibold)
                            .frame(width: width * 0.9, height: 40)
                    }
                }
                .frame(width: width * 0.9, height: 50)
                .background(Color.modal)
                .clipShape(.rect(cornerRadius: 12))
            }
            .background(ClearBackground())
        }
    }
}
