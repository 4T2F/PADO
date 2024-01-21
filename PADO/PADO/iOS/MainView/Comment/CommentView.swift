//
//  CommentView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let comment: String
    let time: String
}

struct CommentSheetView: View {
    let comments: [Comment] = [
        Comment(username: "Yangbaechu", comment: "하하하, 너무 재밌네요...", time: "1분 전"),
        Comment(username: "MinJi", comment: "그쵸! 제가 좀 재밌어요~", time: "3분 전"),
        Comment(username: "BestCha", comment: "잘 모르겠습니다..", time: "4분 전"),
        Comment(username: "A-heung", comment: "이런흥아흥아흥!", time: "5분 전"),
        Comment(username: "pinkso", comment: "솔직히 저 예쁘지 않아요?", time: "8분 전"),
        Comment(username: "dongho", comment: "이런흥아흥아흥!", time: "13분 전"),
        Comment(username: "ciu", comment: "솔직히 저 예쁘지 않아요?", time: "15분 전"),
        Comment(username: "myunghyun", comment: "이런흥아흥아흥!", time: "17분 전"),
        Comment(username: "minchae", comment: "솔직히 저 예쁘지 않아요?", time: "24분 전"),
    ]
    
    @State private var commentText: String = ""
    
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
                        ForEach(comments) { comment in
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
