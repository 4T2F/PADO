//
//  ReplyCommentWriteView.swift
//  PADO
//
//  Created by 최동호 on 2/27/24.
//

import SwiftUI

struct ReplyCommentWriteView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var commentVM: CommentViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var commentText: String = ""
    @State private var isFocused: Bool = false
    
    @State var notiUser: User
    
    @Binding var post: Post
    
    let index: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
                
                Spacer()
               
                Text("답글 달기")
                    .font(.system(size: 16))
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
                            CommentWriteViewCell(index: index,
                                                 commentVM: commentVM,
                                                 post: $post)
                            if !commentVM.comments[index].replyComments.isEmpty {
                                ForEach(commentVM.comments[index].replyComments, id: \.self) { replyCommentID in
                                    ReplyCommentWriteViewCell(index: index,
                                                              replyCommentID: replyCommentID,
                                                              commentVM: commentVM,
                                                              post: $post)
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
                    TextField("\(commentVM.comments[index].userID)님에게 답글 남기기...", text: $commentText, axis: .vertical)
                        .font(.system(size: 14))
                        .tint(Color(.systemBlue).opacity(0.7))
                        .focused($isTextFieldFocused)
                        .onAppear {
                            self.isTextFieldFocused = true
                        }
                    
                    if !commentText.isEmpty {
                        Button {
                            Task {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                
                                if let postID = post.id {
                                    await UpdatePushNotiData.shared.pushPostNoti(targetPostID: postID,
                                                                                 receiveUser: notiUser,
                                                                                 type: .replyComment,
                                                                                 message: commentText,
                                                                                 post: post)
                                    await commentVM.writeReplyComment(post: post,
                                                                      index: index,
                                                                                   imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                                                   inputcomment: commentText)
                                    await commentVM.getReplyCommentsDocument(post: post,
                                                                       index: index)
                                    commentText = ""
                                }
                                dismiss()
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 26)
                                    .frame(width: 48, height: 28)
                                    .foregroundStyle(.blue)
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 14))
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
                                    .font(.system(size: 14))
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


