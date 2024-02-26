//
//  CommentCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import Kingfisher
import Lottie
import SwiftUI

enum CommentType {
    case comment
    case replyComment
}

struct CommentCell: View {
    let index: Int
    
    @State private var isUserLoaded = false
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State private var isShowingReplyCommentWriteView: Bool = false
    @State private var isShowingLoginPage: Bool = false
    @State var buttonOnOff: Bool = false
    @State var isShowingReportView: Bool = false
    @State private var isShowingHeartUserView: Bool = false
    @State private var isHeartCheck: Bool = true

    @Binding var post: Post
    
    var body: some View {
        if index < commentVM.comments.count {
            SwipeAction(cornerRadius: 0, direction: .trailing) {
                    HStack(alignment: .top) {
                        Group {
                            NavigationLink {
                                if let user = commentVM.commentUsers[commentVM.comments[index].userID] {
                                    OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                         user: user)
                                }
                            } label: {
                                if let user = commentVM.commentUsers[commentVM.comments[index].userID] {
                                    CircularImageView(size: .commentSize,
                                                      user: user)
                                }
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.top, 6)
                        
                        VStack(alignment: .leading, spacing: 6) {
                        
                            NavigationLink {
                                if let user = commentVM.commentUsers[commentVM.comments[index].userID] {
                                    OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                         user: user)
                                }
                            } label: {
                                Text(commentVM.comments[index].userID)
                                    .fontWeight(.semibold)
                                    .font(.system(.subheadline))
                                    .padding(.trailing, 4)
                                    .foregroundStyle(.white)
                            }
                            
                            Text(commentVM.comments[index].content)
                                .font(.system(.subheadline))
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 8) {
                                Text(commentVM.comments[index].time.formatDate(commentVM.comments[index].time))
                                    .font(.system(.footnote))
                                    .foregroundColor(.secondary)
                                
                                Button {
                                    Task {
                                        await commentVM.getReplyCommentsDocument(post: post,
                                                                                 index: index)
                                        isShowingReplyCommentWriteView = true
                                    }
                                } label: {
                                    Text("답글 달기")
                                        .font(.system(.caption, weight: .semibold))
                                        .foregroundStyle(Color(.systemGray))
                                }
                                .sheet(isPresented: $isShowingReplyCommentWriteView, content: {
                                    if let user = commentVM.commentUsers[commentVM.comments[index].userID] {
                                        ReplyCommentWriteView(commentVM: commentVM,
                                                         notiUser: user,
                                                              post: $post,
                                                              index: index)
                                        .presentationDragIndicator(.visible)
                                        .presentationDetents([.large])
                                    }
                                })
                                .sheet(isPresented: $isShowingLoginPage) {
                                    StartView(isShowStartView: $isShowingLoginPage)
                                        .presentationDragIndicator(.visible)
                                }
                            }
                            .padding(.top, 2)
                          
                        }
                        .padding(.top, 6)
                        
                        Spacer()
                        
                        Group {
                            VStack(spacing: 4) {
                                Text("")
                                    .fontWeight(.semibold)
                                    .font(.system(.footnote))
                                    .padding(.trailing, 4)
                                
                                if isHeartCheck {
                                    Button {
                                        Task {
                                            await commentVM.deleteCommentHeart(post: post,
                                                                               index: index)
                                            self.isHeartCheck = commentVM.checkCommentHeartExists(index: index)
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
                                            await commentVM.addCommentHeart(post: post,
                                                                            index: index)
                                            
                                            self.isHeartCheck = commentVM.checkCommentHeartExists(index: index)
                                        }
                                    } label: {
                                        Image("heart")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 17, height: 17)
                                    }
                                }
                                
                                if commentVM.comments[index].heartIDs.count > 0 {
                                    Button {
                                        isShowingHeartUserView = true
                                    } label: {
                                        Text("\(commentVM.comments[index].heartIDs.count)")
                                            .font(.system(.footnote))
                                            .foregroundStyle(.gray)
                                    }
                                    .sheet(isPresented: $isShowingHeartUserView, content: {
                                        HeartUsersView(userIDs: commentVM.comments[index].heartIDs)
                                    })
                                }
                                Spacer()
                            }
                        }
                        .padding(.trailing, 10)
                    }
            } actions: {
                Action(tint: .modal, icon: "flag", isEnabled: commentVM.comments[index].userID != userNameID) {
                    DispatchQueue.main.async {
                        commentVM.selectedComment = commentVM.comments[index]
                        commentVM.showReportModal = true
                    }
                }
                
                Action(tint: .modal, icon: "trash", iconTint: Color.red, isEnabled: commentVM.comments[index].userID == userNameID
                       || post.ownerUid == userNameID) {
                    DispatchQueue.main.async {
                        commentVM.selectedComment = commentVM.comments[index]
                        commentVM.showDeleteModal = true
                    }
                }
            }
            .onAppear {
                self.isHeartCheck = commentVM.checkCommentHeartExists(index: index)
                self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: commentVM.comments[index].userID)
            }
            .sheet(isPresented: $commentVM.showDeleteModal) {
                DeleteCommentView(commentVM: commentVM,
                                  post: $post,
                                  commentType: CommentType.comment,
                                  index: nil)
                .presentationDetents([.fraction(0.4)])
            }
            .sheet(isPresented: $commentVM.showReportModal) {
                ReportCommentView(isShowingReportView: $isShowingReportView)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
