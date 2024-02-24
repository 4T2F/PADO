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
        HStack(alignment: .top) {
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
                
                Button {
                    
                } label: {
                    Text("답글달기")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.top, 2)
            
            Spacer()
            
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
            
//            Button {
//                if commentVM.comments[index].userID == userNameID {
//                    commentVM.selectedComment = commentVM.comments[index]
//                    commentVM.showdeleteModal = true
//                } else if post.ownerUid == userNameID {
//                    commentVM.selectedComment = commentVM.comments[index]
//                    commentVM.showselectModal = true
//                } else {
//                    commentVM.selectedComment = commentVM.comments[index]
//                    commentVM.showreportModal = true
//                }
//            } label: {
//                Image(systemName: "ellipsis")
//                    .foregroundStyle(.white)
//            }
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
        .sheet(isPresented: $commentVM.showselectModal) {
            SelectCommentView(commentVM: commentVM,
                              post: $post)
            .presentationDetents([.fraction(0.25)])
            .presentationDragIndicator(.visible)
                
        }
        .sheet(isPresented: $commentVM.showreportModal) {
            ReportCommentView(isShowingReportView: $isShowingReportView)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
