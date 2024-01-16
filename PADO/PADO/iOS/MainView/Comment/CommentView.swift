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
        Comment(username: "Yangbaechu", comment: "하하하, 너무 재밌네요...", time: "15분 전"),
        Comment(username: "MinJi", comment: "그쵸! 제가 좀 재밌어요~", time: "15분 전"),
        Comment(username: "BestCha", comment: "잘 모르겠습니다..", time: "15분 전"),
        Comment(username: "A-heung", comment: "이런흥아흥아흥!", time: "15분 전"),
        Comment(username: "pinkso", comment: "솔직히 저 예쁘지 않아요?", time: "15분 전")
    ]
    
    @State private var commentText: String = ""
    
    var body: some View {
        ZStack {
            Color.mainBackground.ignoresSafeArea()
            VStack {
                Text("댓글")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                
                Divider()
                
                FaceMojiView()
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(comments) { comment in
                            CommentCell(comment: comment)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                        }
                    }
                }
                
                HStack {
                    CircularImageView(size: .large)
                    TextField("DogStar(으)로 답글 달기...", text: $commentText)
                        .frame(height: 18)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                .padding()
            }
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
