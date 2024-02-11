//
//  CommentCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct CommentCell: View {
    let comment: Comment
    
    @State private var commentUser: User? = nil
    @State private var isUserLoaded = false
    
    @ObservedObject var commentVM: CommentViewModel
    
    @State var buttonOnOff: Bool = false
    
    let updateFollowData = UpdateFollowData()
    let post: Post
    let postID: String
    
    var body: some View {
        HStack(alignment: .top) {
            NavigationLink {
                if let user = commentUser {
                    OtherUserProfileView(buttonOnOff: $buttonOnOff, 
                                         updateFollowData: updateFollowData,
                                         user: user)
                }
            } label: {
                if let user = commentUser {
                    if let imageUrl = user.profileImageUrl {
                        KFImage(URL(string: imageUrl))
                            .fade(duration: 0.5)
                            .placeholder{
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                    }
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .padding(.trailing, 6)
                }
                    
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    NavigationLink {
                        if let user = commentUser {
                            OtherUserProfileView(buttonOnOff: $buttonOnOff, updateFollowData: updateFollowData,
                                                 user: user)
                        }
                    } label: {
                        Text(comment.userID)
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.trailing, 4)
                            .foregroundStyle(.white)
                    }
                    
                    Text(comment.time.formatDate(comment.time))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if commentUser?.nameID == userNameID {
                        Button {
                            commentVM.selectedComment = comment
                            commentVM.showdeleteModal = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                        }
                    } else if post.ownerUid == userNameID {
                        // 댓글 삭제, 신고 두개 다 가능한 모달 열리게 해야함
                        Button {
                            commentVM.selectedComment = comment
                            commentVM.showselectModal = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                        }
                    } else {
                        Button {
                            commentVM.selectedComment = comment
                            commentVM.showreportModal = true
                            Task {
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Text(comment.content)
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
            }
            .padding(.top, 2)
        }
        .onAppear {
            Task {
                self.commentUser = await UpdateUserData.shared.getOthersProfileDatas(id: comment.userID)
                self.buttonOnOff = await updateFollowData.checkFollowStatus(id: comment.userID)
            }
        }
        .sheet(isPresented: $commentVM.showdeleteModal) {
            DeleteCommentView(commentVM: commentVM,
                              postID: postID)
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: $commentVM.showselectModal) {
            SelectCommentView(commentVM: commentVM,
                              postID: postID)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
                
        }
        .sheet(isPresented: $commentVM.showreportModal) {
            ReportCommentView(isShowingReportView: $commentVM.showreportModal)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}
