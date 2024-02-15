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
    
    let postID: String
    
    @State var reportArray:[String] = ["부적절한 댓글", "사칭", "스팸", "기타"]
    @State var isShowingReportView: Bool = false
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text("댓글")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .padding(.bottom, 3)
                    .padding(.leading)
                
                VStack {
                    Button {
                        if let selectComment = commentVM.selectedComment {
                            Task {
                                await commentVM.updateCommentData.deleteComment(documentID: postID,
                                                                                commentID: selectComment.userID+(selectComment.time.convertTimestampToString(timestamp: selectComment.time)))
                                if let fetchedComments = await commentVM.updateCommentData.getCommentsDocument(postID: postID) {
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
                                
                                Text("삭제")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                            .frame(height: 30)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    ForEach(reportArray, id: \.self) { reportReason in
                        ReportSelectCellView(isShowingReportView: $isShowingReportView, text: reportReason)
                            .padding(.bottom, 10)
                    }
                }
            }
            
        }
        .background(.modal, ignoresSafeAreaEdges: .all)
        .onAppear {
            
        }
    }
}
