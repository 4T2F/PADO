//
//  CommentWriteCell.swift
//  PADO
//
//  Created by 최동호 on 2/26/24.
//

import Kingfisher
import Lottie
import SwiftUI

struct CommentWriteViewCell: View {
    let index: Int
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State var buttonOnOff: Bool = false
    @State var isShowingReportView: Bool = false
    @State private var isShowingHeartUserView: Bool = false
    @State private var isHeartCheck: Bool = true
    @State private var isUserLoaded = false
    
    @Binding var post: Post
    
    var body: some View {
        if index < commentVM.comments.count {
            
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
                    
                    Text(commentVM.comments[index].time.formatDate(commentVM.comments[index].time))
                        .font(.system(.footnote))
                        .foregroundColor(.secondary)
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
            .onAppear {
                self.isHeartCheck = commentVM.checkCommentHeartExists(index: index)
                self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: commentVM.comments[index].userID)
            }
        }
    }
}
