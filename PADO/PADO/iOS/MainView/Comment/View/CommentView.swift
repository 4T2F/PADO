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
    
    @State private var commentText: String = ""
    @State private var isShowingComment: Bool = false
    @State var postUser: User
    
    let post: Post
    let postID: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                
                ScrollView {
                    VStack {
                        if let postID = post.id {
                            FaceMojiView(commentVM: commentVM,
                                         postOwner: $postUser,
                                         post: post,
                                         postID: postID)
                            .padding(2)
                        }
                        
                        Divider()
                    }
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        if !commentVM.comments.isEmpty, let postID = post.id {
                            ForEach(commentVM.comments) { comment in
                                CommentCell(comment: comment,
                                            commentVM: commentVM,
                                            post: post,
                                            postID: postID)
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
                
                Divider()
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    isShowingComment.toggle()
                } label: {
                    HStack(spacing: 6) {
                        CircularImageView(size: .xxxSmall, user: postUser)
                        if post.ownerUid == userNameID {
                            Text("나의 파도에 댓글 남기기")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                                .padding(.leading, 2)
                        } else {
                            Text("\(post.ownerUid)님의 파도에 댓글 남기기")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                                .padding(.leading, 2)
                        }
                        
                        Spacer()
                    }
                    .padding(10)
                    .background(.commentButton)
                    .clipShape(Capsule())
                }
                .padding(10)
                .sheet(isPresented: $isShowingComment, content: {
                    CommentWriteView(commentVM: commentVM, isShowingComment: $isShowingComment, postUser: postUser, post: post)
                        .presentationDragIndicator(.visible)
                })
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("댓글")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingCommentView = false
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Text("닫기")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
        }
        .background(.main, ignoresSafeAreaEdges: .all)
    }
}
