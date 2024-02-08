//
//  ReCommentView.swift
//  PADO
//
//  Created by 강치우 on 2/3/24.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    
    @Binding var isShowingCommentView: Bool
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var commentText: String = ""
    @State var postUser: User
    
    let post: Post
    let postID: String
    
    var body: some View {
        NavigationStack {
            HStack {
                Button {
                    isShowingCommentView = false
                } label: {
                    Text("취소")
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Text("댓글 달기")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.trailing, 30)
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 50)
            
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        if let postID = post.id {
                            FaceMojiView(feedVM: feedVM,
                                         surfingVM: surfingVM,
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
                        if !feedVM.comments.isEmpty, let postID = post.id {
                            ForEach(feedVM.comments) { comment in
                                CommentCell(comment: comment, feedVM: feedVM, postID: postID)
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
            .background(.modal)
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
                                    await feedVM.updatePushNotiData.pushPostNoti(targetPostID: postID, receiveUser: postUser, type: .comment, message: commentText)
                                    await feedVM.updateCommentData.writeComment(documentID: postID,
                                                                                imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                                                inputcomment: commentText)
                                    if let fetchedComments = await feedVM.updateCommentData.getCommentsDocument(postID: postID) {
                                        feedVM.comments = fetchedComments
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
                feedVM.comments.removeAll()
                if let postID = post.id {
                    if let fetchedComments = await feedVM.updateCommentData.getCommentsDocument(postID: postID) {
                        feedVM.comments = fetchedComments
                    }
                }
                //                try await feedVM.getFaceMoji()
            }
        }
    }
}
