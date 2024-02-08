//
//  ReCommentView.swift
//  PADO
//
//  Created by 강치우 on 2/3/24.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var commentVM = CommentViewModel()
    
    @Binding var isShowingCommentView: Bool
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var commentText: String = ""
    @State var postUser: User
    
    let post: Post
    let postID: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        if let postID = post.id {
                            FaceMojiView(commentVM: commentVM,
                                         postOwner: $postUser,
                                         post: post,
                                         postID: postID)
                            .padding(2)
                        }
                        
                        
                        Divider()
                            .opacity(0.5)
                    }
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        if !commentVM.comments.isEmpty, let postID = post.id {
                            ForEach(commentVM.comments) { comment in
                                CommentCell(comment: comment, commentVM: commentVM, postID: postID)
                                    .id(comment.id)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 20)
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
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationTitle("댓글 달기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingCommentView = false
                    } label: {
                        Text("취소")
                            .font(.system(size: 16))
                    }
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
            .offset(y: -7)
            
            HStack {
                if let user = viewModel.currentUser {
                    CircularImageView(size: .small, user: user)
                }
                
                HStack {
                    TextField("\(userNameID)(으)로 댓글 남기기...",
                              text: $commentText,
                              axis: .vertical) // 세로 축으로 동적 높이 조절 활성화
                    .font(.system(size: 14))
                    .tint(Color(.systemBlue))
                    .focused($isTextFieldFocused)
                    .onAppear {
                        isTextFieldFocused = true
                    }
                    
                    if !commentText.isEmpty {
                        Button {
                            Task {
                                if let postID = post.id {
                                    await UpdatePushNotiData.shared.pushPostNoti(targetPostID: postID,
                                                                                 receiveUser: postUser,
                                                                                 type: .comment,
                                                                                 message: commentText)
                                    await commentVM.updateCommentData.writeComment(documentID: postID,
                                                                                imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                                                inputcomment: commentText)
                                    if let fetchedComments = await commentVM.updateCommentData.getCommentsDocument(postID: postID) {
                                        commentVM.comments = fetchedComments
                                    }
                                    commentText = ""
                                }
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
            .frame(height: 30)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            Task {
                print(postUser)
                commentVM.comments.removeAll()
                if let postID = post.id {
                    if let fetchedComments = await commentVM.updateCommentData.getCommentsDocument(postID: postID) {
                        commentVM.comments = fetchedComments
                    }
                }
                //                try await feedVM.getFaceMoji()
            }
        }
    }
}
