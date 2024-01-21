//
//  CommentView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct CommentSheetView: View {
    @State private var commentText: String = ""
    
    @StateObject private var commentVM = CommentViewModel()
    
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
                HStack {
                    CircularImageView(size: .medium)
                    TextField("sirius(으)로 답글 달기...", text: $commentText)
                        .frame(height: 12)
                        .font(.system(size: 14))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .strokeBorder(Color.gray, lineWidth: 0.5)
                        )
                }
                .padding(.horizontal)
            }
            .padding(.top, 30)
        }
    }
}

struct CommentView: View {
    var body: some View {
        CommentSheetView()
    }
}

#Preview {
    CommentSheetView()
}
