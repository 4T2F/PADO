//
//  deleteCommentView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import SwiftUI

struct DeleteCommentView: View {
    // MARK: - PROPERTY
    let comment: Comment
    
    @ObservedObject var feedVM: FeedViewModel

    let postID: String
    // MARK: - BODY
    var body: some View {
        VStack {
            Text("댓글 삭제")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            VStack {
                Text("\(comment.content) 를")
                    .font(.system(size: 16))
                    .lineLimit(2)
                    .padding()
                
                Text("삭제 하시겠습니까?")
                    .font(.system(size: 16))
                    .padding()
                
                Button {
                    feedVM.showdeleteModal = false
                    Task {
                        await feedVM.updateCommentData.deleteComment(documentID: postID,
                                                              commentID: userNameID+(comment.time.convertTimestampToString(timestamp: comment.time)))
                        if let fetchedComments = await feedVM.updateCommentData.getCommentsDocument(postID: postID) {
                            feedVM.comments = fetchedComments
                        }
                    }
                } label: {
                    Text("삭제")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.red)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
                
                Button {
                    feedVM.showdeleteModal = false
                } label: {
                    Text("취소")
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.grayButton)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
            }
        }
        .padding()
    }
}
