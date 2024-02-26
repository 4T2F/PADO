//
//  ReplyCommentCell.swift
//  PADO
//
//  Created by 최동호 on 2/27/24.
//

import Kingfisher
import Lottie
import SwiftUI

struct ReplyCommentCell: View {
    let index: Int
    let replyCommentID: String
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State private var isUserLoaded = false
    @State private var isShowingCommentWriteView: Bool = false
    @State private var isShowingLoginPage: Bool = false
    @State var buttonOnOff: Bool = false
    @State private var isShowingReportView: Bool = false
    @State private var isShowingHeartUserView: Bool = false
    @State private var isHeartCheck: Bool = true
    @State var commentUser: User?
    
    @Binding var post: Post
    
    var body: some View {
        if index < commentVM.comments.count, let replyComment = commentVM.replyComments[replyCommentID] {
            SwipeAction(cornerRadius: 0, direction: .trailing) {
                HStack(alignment: .top) {
                    Circle()
                        .foregroundStyle(.clear)
                        .frame(width: 38, height: 38)
                        .padding(.leading, 10)
                        .padding(.top, 6)
                    Group {
                        NavigationLink {
                            if let user = commentUser {
                                OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                     user: user)
                            }
                        } label: {
                            if let user = commentUser {
                                CircularImageView(size: .xxxSmall,
                                                  user: user)
                            }
                        }
                    }
                    .padding(.top, 6)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        NavigationLink {
                            if let user = commentUser {
                                OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                     user: user)
                            }
                        } label: {
                            Text(replyComment.userID)
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                                .padding(.trailing, 4)
                                .foregroundStyle(.white)
                        }
                        
                        Text(replyComment.content)
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                        
                        Text(replyComment.time.formatDate(replyComment.time))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                        
                    }
                    .padding(.top, 6)
                    
                    Spacer()
                    
                    Group {
                        VStack(spacing: 4) {
                            Text("")
                                .fontWeight(.semibold)
                                .font(.system(size: 12))
                                .padding(.trailing, 4)
                            
                            if isHeartCheck {
                                Button {
                                    Task {
                                        await commentVM.deleteReplyCommentHeart(post: post,
                                                                                index: index,
                                                                                replyComment: replyComment)
                                        if let replyComment = commentVM.replyComments[replyCommentID] {
                                            self.isHeartCheck = commentVM.checkReplyCommentHeartExists(replyComment: replyComment)
                                        }
                                    }
                                } label: {
                                    Circle()
                                        .frame(width: 17)
                                        .foregroundStyle(.clear)
                                        .overlay {
                                            LottieView(animation: .named("Heart"))
                                                .playing()
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 34, height: 34)
                                        }
                                }
                            } else {
                                Button {
                                    Task {
                                        await commentVM.addReplyCommentHeart(post: post,
                                                                        index: index,
                                                                        replyComment: replyComment)
                                        if let replyComment = commentVM.replyComments[replyCommentID] { 
                                            self.isHeartCheck = commentVM.checkReplyCommentHeartExists(replyComment: replyComment)
                                        }
                                    }
                                } label: {
                                    Image("heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 17, height: 17)
                                }
                            }
                            
                            if replyComment.heartIDs.count > 0 {
                                Button {
                                    isShowingHeartUserView = true
                                } label: {
                                    Text("\(replyComment.heartIDs.count)")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray)
                                }
                                .sheet(isPresented: $isShowingHeartUserView, content: {
                                    HeartUsersView(userIDs: replyComment.heartIDs)
                                })
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.trailing, 10)
                }
            } actions: {
                Action(tint: .modal, icon: "flag", isEnabled: replyComment.userID != userNameID) {
                    DispatchQueue.main.async {
                        commentVM.selectedReplyComment = replyComment
                        commentVM.showReportReplyModal = true
                    }
                }
                
                Action(tint: .modal, icon: "trash", iconTint: Color.red, isEnabled: replyComment.userID == userNameID
                       || post.ownerUid == userNameID) {
                    DispatchQueue.main.async {
                        commentVM.selectedReplyComment = replyComment
                        commentVM.showDeleteReplyModal = true
                    }
                }
            }
            .onAppear {
                Task {
                    if let replyComment = commentVM.replyComments[replyCommentID] {
                        if let user = await UpdateUserData.shared.getOthersProfileDatas(id: replyComment.userID) {
                         
                            self.commentUser = user
                            
                            self.isHeartCheck = commentVM.checkReplyCommentHeartExists(replyComment: replyComment)
                            
                            self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: user.nameID)
                        }
                    }
                }
            }
            .sheet(isPresented: $commentVM.showDeleteReplyModal) {
                DeleteCommentView(commentVM: commentVM,
                                  post: $post,
                                  commentType: CommentType.replyComment,
                                  index: index)
                .presentationDetents([.fraction(0.4)])
            }
            .sheet(isPresented: $commentVM.showReportReplyModal) {
                ReportCommentView(isShowingReportView: $isShowingReportView)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

