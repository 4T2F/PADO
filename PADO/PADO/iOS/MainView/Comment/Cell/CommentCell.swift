//
//  CommentCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import Kingfisher
import Lottie
import SwiftUI

struct CommentCell: View {
    let index: Int
    
    @State private var isUserLoaded = false
    
    @ObservedObject var commentVM: CommentViewModel
    
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
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                NavigationLink {
                                    if let user = commentVM.commentUsers[commentVM.comments[index].userID] {
                                        OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                             user: user)
                                    }
                                } label: {
                                    Text(commentVM.comments[index].userID)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 12))
                                        .padding(.trailing, 4)
                                        .foregroundStyle(.white)
                                }
                                
                                Text(commentVM.comments[index].time.formatDate(commentVM.comments[index].time))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                
                            }
                            
                            Text(commentVM.comments[index].content)
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                            
                            //                    Button {
                            //
                            //                    } label: {
                            //                        Text("답글달기")
                            //                            .font(.system(size: 10))
                            //                            .foregroundStyle(.gray)
                            //                    }
                        }
                        .padding(.top, 6)
                        
                        Spacer()
                        
                        Group {
                            VStack(spacing: 4) {
                                Spacer()
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
                                            .font(.system(size: 12))
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
                        commentVM.showreportModal = true
                    }
                }
                
                Action(tint: .modal, icon: "trash", iconTint: Color.red, isEnabled: commentVM.comments[index].userID == userNameID
                       || post.ownerUid == userNameID) {
                    DispatchQueue.main.async {
                        commentVM.selectedComment = commentVM.comments[index]
                        commentVM.showdeleteModal = true
                    }
                }
            }
            .onAppear {
                self.isHeartCheck = commentVM.checkCommentHeartExists(index: index)
                self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: commentVM.comments[index].userID)
            }
            .sheet(isPresented: $commentVM.showdeleteModal) {
                DeleteCommentView(commentVM: commentVM,
                                  post: $post)
                .presentationDetents([.fraction(0.4)])
            }
            .sheet(isPresented: $commentVM.showreportModal) {
                ReportCommentView(isShowingReportView: $isShowingReportView)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
