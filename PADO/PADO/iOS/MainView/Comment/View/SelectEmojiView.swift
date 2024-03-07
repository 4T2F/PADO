//
//  SelectEmojiView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import SwiftUI

let emojiColors: [String: Color] = [
    "None": .white,
    "👍": .green,
    "🥰": .pink,
    "🤣": .yellow,
    "😡": .orange,
    "😢": .blue
]

struct SelectEmojiView: View {
    @ObservedObject var commentVM: CommentViewModel
    
    @Binding var postOwner: User
    @Binding var post: Post
    
    let postID: String
    let emojis = ["None", "👍", "🥰", "🤣", "😡", "😢"]
    
    var body: some View {
        ZStack {
            Color.main.ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(emojiColors[commentVM.selectedEmoji, default: .white], lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    commentVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    if commentVM.selectedEmoji != "None" {
                        Text(commentVM.selectedEmoji)
                            .offset(x: 40, y: 35)
                    }
                }
                Spacer()
                Text("포토모지의 이모티콘을 선택해주세요")
                    .font(.system(.body))
                
                emojiPicker
                
                submitButton
                    .padding(.bottom, 20)
            }
        }
    }
    
    var emojiPicker: some View {
        VStack {
            ForEach(Array(emojis.chunked(into: 3)), id: \.self) { chunk in
                HStack {
                    ForEach(chunk, id: \.self) { emoji in
                        Button(action: {
                            commentVM.selectedEmoji = emoji
                        }) {
                            if emoji == "None" {
                                Text(emoji)
                                    .font(.system(.subheadline))
                            } else {
                                Text(emoji)
                                    .font(.system(.title2))
                            }
                        }
                        .frame(width: 45, height: 45)
                        .padding()
                    }
                }
            }
        }
    }
    
    var submitButton: some View {
        Button(action: {
            Task {
                await commentVM.updatePhotoMojiData.updateEmoji(documentID: postID,
                                                               emoji: commentVM.selectedEmoji)
                if let cropImage = commentVM.cropMojiUIImage {
                    try await commentVM.updatePhotoMojiData.updatePhotoMoji(cropMojiUIImage: cropImage,
                                                                          documentID: postID,
                                                                          selectedEmoji: commentVM.selectedEmoji)
                }
                commentVM.photoMojies = try await commentVM.updatePhotoMojiData.getPhotoMoji(documentID: postID) ?? []
                await UpdatePushNotiData.shared.pushPostNoti(targetPostID: postID,
                                                             receiveUser: postOwner,
                                                             type: .photoMoji,
                                                             message: "",
                                                             post: post)
            }
            commentVM.showEmojiView = false
            commentVM.showCropPhotoMoji = false
        }) {
            Text("포토모지 올리기")
                .font(.system(.body, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
