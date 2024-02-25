//
//  CommentWriteView.swift
//  PADO
//
//  Created by 강치우 on 2/10/24.
//

import SwiftUI

struct CommentWriteView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var commentVM: CommentViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var commentText: String = ""
    @State private var isFocused: Bool = false
    
    @State var postUser: User
    
    @Binding var post: Post
    
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
                
                Text("댓글 달기")
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
                        if !commentVM.comments.isEmpty {
                            ForEach(commentVM.comments.indices, id:\.self) { index in
                                CommentCell(index: index,
                                            commentVM: commentVM,
                                            post: $post)
                                .id(index)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    if let lastCommentID = commentVM.comments.last?.id {
                                        withAnimation {
                                            value.scrollTo(lastCommentID, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        } else {
                            VStack {
                                Text("아직 댓글이 없습니다.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.bottom, 10)
                                    .padding(.top, 120)
                                Text("댓글을 남겨보세요.")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .padding(.bottom, 6)
            
            Divider()
            
            HStack {
                if let user = viewModel.currentUser {
                    CircularImageView(size: .small, user: user)
                }
                
                HStack {
                    TextField("\(userNameID)(으)로 댓글 남기기...", text: $commentText, axis: .vertical)
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
                                                                                 receiveUser: postUser,
                                                                                 type: .comment,
                                                                                 message: commentText,
                                                                                 post: post)
                                    await commentVM.writeComment(post: post,
                                                                                   imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                                                   inputcomment: commentText)
                                    
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
