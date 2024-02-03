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
    
    @ObservedObject var feedVM: FeedViewModel
    var body: some View {
        HStack(alignment: .top) {
            NavigationLink {
                if let user = commentUser {
                    OtherUserProfileView(user: user)
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
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    NavigationLink {
                        if let user = commentUser {
                            OtherUserProfileView(user: user)
                        }
                    } label: {
                        Text(comment.userID)
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.trailing, 4)
                            .foregroundStyle(.white)
                    }
                    
                    Text(TimestampDateFormatter.formatDate(comment.time))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if commentUser?.nameID == userNameID {
                        Button {
                            Task {
                                await feedVM.deleteComment(commentID: userNameID+TimestampDateFormatter.convertTimestampToString(timestamp: comment.time))
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.white)
                        }
                    } else {
                        Button {
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
            }
            
        }

    }
}
