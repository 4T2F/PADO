//
//  ReplyCommentWriteView.swift
//  PADO
//
//  Created by 최동호 on 2/27/24.
//

import SwiftUI

struct ReplyCommentWriteView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State var notiUser: User
    
    @Binding var post: Post
    
    @FocusState private var isTextFieldFocused: Bool
    
    let index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(.body))
                        .fontWeight(.medium)
                }
                
                Spacer()
               
                Text("답글 달기")
                    .font(.system(.body))
                    .fontWeight(.semibold)
                    .padding(.trailing, 30)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 15)
            
            Divider()
            
            ScrollView {
                ScrollViewReader { value in
                    VStack(alignment: .leading) {
                        if index < commentVM.comments.count {
                            CommentWriteViewCell(
                                commentVM: commentVM, 
                                post: $post,
                                index: index
                            )
                            if !commentVM.comments[index].replyComments.isEmpty {
                                ForEach(commentVM.comments[index].replyComments, id: \.self) { replyCommentID in
                                    ReplyCommentWriteViewCell(commentVM: commentVM,
                                                              post: $post,
                                                              index: index, 
                                                              replyCommentID: replyCommentID)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .padding(.bottom, 6)
            
            Divider()
            
            HStack {
                CircularImageView(size: .small, user: notiUser)

                HStack {
                    TextField("\(commentVM.comments[index].userID)님에게 답글 남기기...", text: $commentVM.commentText, axis: .vertical)
                        .font(.system(.body))
                        .tint(Color(.systemBlue).opacity(0.7))
                        .focused($isTextFieldFocused)
                        .onAppear {
                            self.isTextFieldFocused = true
                        }
                    
                    if !commentVM.commentText.isEmpty {
                        Button {
                            Task {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                
                                if let postID = post.id {
                                    await UpdatePushNotiData.shared.pushPostNoti(
                                        targetPostID: postID,
                                        receiveUser: notiUser,
                                        type: .replyComment,
                                        message: commentVM.commentText,
                                        post: post
                                    )
                                    await commentVM.writeReplyComment(
                                        post: post,index: index,
                                        imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                        inputcomment: commentVM.commentText
                                    )
                                    await commentVM.getReplyCommentsDocument(
                                        post: post,
                                        index: index
                                    )
                                    commentVM.commentText = ""
                                }
                                dismiss()
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 26)
                                    .frame(width: 48, height: 28)
                                    .foregroundStyle(.blue)
                                Image(systemName: "arrow.up")
                                    .font(.system(.body))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.vertical, -5)
                    } else {
                        Button {
                            //
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 26)
                                    .frame(width: 48, height: 28)
                                    .foregroundStyle(.gray)
                                Image(systemName: "arrow.up")
                                    .font(.system(.subheadline))
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .vertical], 8)
        }
        .background(.main, ignoresSafeAreaEdges: .all)
    }
}


