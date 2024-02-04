//
//  SelectEmojiView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import SwiftUI

struct SelectEmojiView: View {
    @ObservedObject var feedVM: FeedViewModel
    
    let emojis = ["None", "👍", "🥰", "🤣", "😡", "😢"]
    let emojiColors: [String: Color] = [
        "None": .white,
        "👍": .green,
        "🥰": .pink,
        "🤣": .yellow,
        "😡": .orange,
        "😢": .blue
    ]
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(.black)
                    .stroke(emojiColors[feedVM.selectedEmoji, default: .white], lineWidth: 3.0)
                    .frame(width: 102, height: 102)
                
                feedVM.cropMojiImage
                    .resizable()
                    .frame(width: 100, height: 100)
                
                if feedVM.selectedEmoji != "None" {
                    Text(feedVM.selectedEmoji)
                        .offset(x: 40, y: 35)
                }
            }
            Spacer()
            Text("FaceMoji의 이모티콘을 선택해주세요")
                .font(.system(size: 16))
            
            emojiPicker
            
            submitButton
                .padding(.bottom, 20)
        }
    }
    
    var emojiPicker: some View {
        VStack {
            ForEach(Array(emojis.chunked(into: 3)), id: \.self) { chunk in
                HStack {
                    ForEach(chunk, id: \.self) { emoji in
                        Button(action: {
                            feedVM.selectedEmoji = emoji
                        }) {
                            if emoji == "None" {
                                Text(emoji)
                                    .font(.system(size: 14))
                            } else {
                                Text(emoji)
                                    .font(.system(size: 20))
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
            feedVM.updateEmoji(emoji: feedVM.selectedEmoji)
        }) {
            Text("페이스모지 올리기")
                .font(.system(size: 16, weight: .semibold))
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
