//
//  CommentView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct CommentSheetView: View {
    @State private var commentText: String = ""
    @ObservedObject var commentVM: CommentViewModel
    @ObservedObject var feedVM: FeedViewModel
    
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
                        ForEach(commentVM.comments) { comment in
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
                            TextEditor(text: $commentText)
                                .font(.system(size: 14))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 26)
                                        .strokeBorder(Color.gray, lineWidth: 0.5)
                                )
                                .frame(height: 50)
                            
                            
                            HStack {
                                Spacer()
                                
                                Button {
                                    // 댓글 입력 로직
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 26)
                                            .frame(width: 50, height: 30)
                                            .foregroundStyle(.blue)
                                        Image(systemName: "arrow.up")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 30)
        }
    }
}

struct CommentView: View {
    @ObservedObject var commentVM: CommentViewModel
    @ObservedObject var feedVM: FeedViewModel
    
    var body: some View {
        CommentSheetView(commentVM: commentVM, feedVM: feedVM)
    }
}
