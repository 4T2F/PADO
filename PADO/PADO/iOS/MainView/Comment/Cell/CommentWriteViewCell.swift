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
    @ObservedObject var commentVM: CommentViewModel
    
    @State var buttonOnOff: Bool = false
    
    @Binding var post: Post
    
    @State private var isHeartCheck: Bool = true
    
    let index: Int
    
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
                .padding(.trailing, 10)
                
                Spacer()
            
            }
            .onAppear {
                self.isHeartCheck = commentVM.checkCommentHeartExists(index: index)
                self.buttonOnOff =  UpdateFollowData.shared.checkFollowingStatus(id: commentVM.comments[index].userID)
            }
        }
    }
}
