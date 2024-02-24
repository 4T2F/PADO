//
//  SelectCommentView.swift
//  PADO
//
//  Created by 최동호 on 2/11/24.
//

import Foundation

import SwiftUI

struct SelectCommentView: View {
    // MARK: - PROPERTY
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var commentVM: CommentViewModel
    
    @Binding var post: Post
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text("댓글")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .padding(.top, 30)
                    .padding(.leading)
                
                Spacer()
                
                Button {
                    if let selectComment = commentVM.selectedComment {
                        Task {
                            await commentVM.updateCommentData.deleteComment(post: post,
                                                                            commentID: selectComment.userID+(selectComment.time.convertTimestampToString(timestamp: selectComment.time)))
                            if let fetchedComments = await commentVM.updateCommentData.getCommentsDocument(post: post) {
                                commentVM.comments = fetchedComments
                            }
                            
                            commentVM.showselectModal = false
                        }
                    }
                    commentVM.showselectModal = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 45)
                            .foregroundStyle(.modalCell)
                        HStack {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: 6)
                                .padding(.trailing, 10)
                                .overlay {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 14))
                                }
             
                            Text("삭제")
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                        .frame(height: 30)
                    }
                }
                .padding(.bottom, 10)
                
                Button {
                    Task {
                        commentVM.showselectModal = false
                        try? await Task.sleep(nanoseconds: 1 * 500_000_000)
                        commentVM.showreportModal = true
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 45)
                            .foregroundStyle(.modalCell)
                        HStack {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: 6)
                                .padding(.trailing, 10)
                                .overlay {
                                    Image(systemName: "light.beacon.max")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 14))
                                }
  
                            Text("신고")
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                        
                            Spacer()
                            
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                        .frame(height: 30)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(.modal, ignoresSafeAreaEdges: .all)
        
    }
}
