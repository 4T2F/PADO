//
//  ReCommentView.swift
//  PADO
//
//  Created by 강치우 on 2/3/24.
//

import Lottie
import SwiftUI

struct CommentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var commentVM = CommentViewModel()
    
    @State private var isShowingCommentWriteView: Bool = false
    @State private var commentText: String = ""
    @State private var isFetchedComment: Bool = false
    @State private var isShowingLoginPage: Bool = false
    @State var postUser: User
    @State var post: Post
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ScrollView {
                VStack {
                    if let postID = post.id {
                        FaceMojiView(commentVM: commentVM,
                                     postOwner: $postUser,
                                     post: $post,
                                     postID: postID)
                        .padding(2)
                    }
                    Divider()
                }
                .padding(.top)
                
                VStack(alignment: .leading) {
                    if isFetchedComment {
                        if !commentVM.comments.isEmpty {
                            ForEach(commentVM.comments.indices, id:\.self) { index in
                                if index < commentVM.comments.count,
                                   commentVM.commentUsers.keys.contains(commentVM.comments[index].userID) {
                                    CommentCell(index: index,
                                                commentVM: commentVM,
                                                post: $post)
                                    .id(index)
                                    if !commentVM.comments[index].replyComments.isEmpty {
                                       ShowMoreCommentView(commentVM: commentVM,
                                                           post: $post,
                                                           index: index)
                                    }
                                }
                            }
                        } else {
                            VStack {
                                Text("아직 댓글이 없습니다.")
                                    .font(.system(.body, weight: .semibold))
                                    .padding(.bottom, 10)
                                    .padding(.top, 120)
                                Text("댓글을 남겨보세요.")
                                    .font(.system(.footnote))
                                    .foregroundStyle(.gray)
                            }
                        } 
                    } else {
                        LottieView(animation: .named("Loading"))
                            .looping()
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 60)
                    }
                }
                .padding(.top)
            }
            .padding(.bottom, 6)
            .onAppear {
                Task {
                    enteredNavigation = true
                    await commentVM.getCommentsDocument(post: post)
                    commentVM.removeDuplicateUserIDs(from: commentVM.comments)
                    await commentVM.fetchCommentUser()
                    isFetchedComment = true
                }
            }
    
            
            Divider()
            
            Button {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                if !userNameID.isEmpty {
                    isShowingCommentWriteView.toggle()
                } else {
                    isShowingLoginPage = true
                }
            } label: {
                HStack(spacing: 6) {
                    CircularImageView(size: .xxxSmall, user: postUser)
                    if post.ownerUid == userNameID {
                        Text("나의 파도에 댓글 남기기")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .padding(.leading, 2)
                    } else {
                        Text("\(post.ownerUid)님의 파도에 댓글 남기기")
                            .font(.system(.subheadline))
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
            .sheet(isPresented: $isShowingCommentWriteView, content: {
                CommentWriteView(commentVM: commentVM, 
                                 notiUser: postUser,
                                 post: $post)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
            })
            .sheet(isPresented: $isShowingLoginPage) {
                StartView(isShowStartView: $isShowingLoginPage)
                    .presentationDragIndicator(.visible)
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("댓글")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: resetNavigation) { _, _ in
            dismiss()
        }
        .onDisappear {
            enteredNavigation = false
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(.body))
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
        
    }
}
