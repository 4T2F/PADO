//
//  ReCommentView.swift
//  PADO
//
//  Created by 강치우 on 2/3/24.
//

import SwiftUI

struct ReCommentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    
    @State private var commentText: String = ""
    
    var body: some View {
        HStack {
            Text("취소")
                .font(.system(size: 16))
            
            Spacer()
            
            Text("댓글 달기")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .padding(.trailing, 30)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(.modal)
        
        ScrollView {
            VStack {
                FaceMojiView(feedVM: feedVM, surfingVM: surfingVM)
                    .padding(2)
                
                Divider()
                    .opacity(0.5)
            }
            .padding(.top)
            
            VStack(alignment: .leading) {
                if feedVM.comments.isEmpty {
                    VStack {
                        Text("아직 댓글이 없습니다.")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.bottom, 10)
                            .padding(.top, 120)
                        Text("댓글을 남겨보세요.")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                } else {
                    ForEach(feedVM.comments) { comment in
                        CommentCell(comment: comment, feedVM: feedVM)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 20)
                    }
                }
            }
            .padding(.top)
        }
        .background(.modal)
        .offset(y: -7)
        
        HStack {
            if let user = viewModel.currentUser {
                CircularImageView(size: .small, user: user)
            }
            
            HStack {
                TextField("\(userNameID)(으)로 댓글 남기기...",
                          text: $commentText,
                          axis: .vertical) // 세로 축으로 동적 높이 조절 활성화
                .font(.system(size: 14))
                .tint(Color(.systemBlue))
                
                if !commentText.isEmpty {
                    Button {
                        Task {
                            await feedVM.writeComment(inputcomment: commentText)
                            commentText = ""
                            await feedVM.getCommentsDocument()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .frame(width: 48, height: 28)
                                .foregroundStyle(.blue)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.vertical, -5)
                } else {
                    Button {
                        //
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .frame(width: 48, height: 28)
                                .foregroundStyle(.gray)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 14))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
        .padding(.bottom)
    }
}
