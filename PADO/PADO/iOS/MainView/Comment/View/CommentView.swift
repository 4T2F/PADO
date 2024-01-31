//
//  CommentView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct CommentView: View {
    @State private var commentText: String = ""
    @ObservedObject var feedVM: FeedViewModel
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            VStack {
                Text("댓글")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                
                VStack(spacing: 14) {
                    
                    Divider()
                    
                    FaceMojiView()
                        .padding(2)
                    
                    Divider()
                }
                .padding(.top, 5)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(feedVM.comments) { comment in
                            CommentCell(comment: comment)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 20)
                        }
                    }
                    .padding(.top)
                }
                .offset(y: -7)
                
                Divider()
                    .offset(y: -14)
                ZStack {
                    HStack {
                        CircularImageView(size: .medium)
                        
                        ZStack {
                            VStack {
                                HStack {
                                    TextField("\(userNameID)(으)로 댓글 달기...",
                                              text: $commentText,
                                              axis: .vertical) // 세로 축으로 동적 높이 조절 활성화
                                    .font(.system(size: 14))
                                    if !commentText.isEmpty {
                                        Button {
                                            Task {
                                                await feedVM.writeComment(inputcomment: commentText)
                                                commentText = ""
                                                await feedVM.getCommentsDocument()
                                            }
                                        } label: {
                                            Image(systemName: "paperplane.fill")
                                                .resizable()
                                                .frame(width: 18, height: 18)
                                                .foregroundStyle(Color(.systemBlue))
                                                .bold()
                                                
                                        }
                                        .padding(.vertical, -5)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30) // HStack의 크기에 맞게 동적으로 크기가 변하는 RoundedRectangle
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 30)
        }
    }
}
