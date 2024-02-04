//
//  SelectEmojiView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import SwiftUI

struct SelectEmojiView: View {
    // MARK: - PROPERTY
    //    let facemoji: Facemoji
    
    @ObservedObject var feedVM: FeedViewModel
    
    // MARK: - BODY
    var body: some View {
        VStack {
            if feedVM.selectedEmoji == "Basic" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.white, lineWidth: 1.4)
                        .frame(width: 70, height: 70)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
            } else if feedVM.selectedEmoji == "👍" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.green, lineWidth: 1.4)
                        .frame(width: 70, height: 70)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
            } else if feedVM.selectedEmoji == "🥰" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.pink, lineWidth: 1.4)
                        .frame(width: 70, height: 70)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
            } else if feedVM.selectedEmoji == "🤣" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.yellow, lineWidth: 1.4)
                        .frame(width: 70, height: 70)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
            } else if feedVM.selectedEmoji == "😡" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.orange, lineWidth: 1.4)
                        .frame(width: 70, height: 70)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
            } else if feedVM.selectedEmoji == "😢" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.blue, lineWidth: 1.4)
                        .frame(width: 70, height: 70)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
            }
            
            Text("FaceMoji의 이모티콘을 선택해주세요")
            
            HStack {
                Button {
                    feedVM.selectedEmoji = "Basic"
                } label: {
                    Text("Basic")
                        .background(.grayButton)
                }
                
                Button {
                    feedVM.selectedEmoji = "👍"
                } label: {
                    Text("👍")
                        .background(.grayButton)
                }
                
                Button {
                    feedVM.selectedEmoji = "🥰"
                } label: {
                    Text("🥰")
                        .background(.grayButton)
                }
            }
            
            HStack {
                Button {
                    feedVM.selectedEmoji = "🤣"
                } label: {
                    Text("🤣")
                        .background(.grayButton)
                }
                
                Button {
                    feedVM.selectedEmoji = "😡"
                } label: {
                    Text("😡")
                        .background(.grayButton)
                }
                
                Button {
                    feedVM.selectedEmoji = "😢"
                } label: {
                    Text("😢")
                        .background(.grayButton)
                }
            }
            
            Button {
                feedVM.updateEmoji(emoji: feedVM.selectedEmoji)
            } label: {
                Text("페이스모지 게시")
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            }
        }
    }
}
