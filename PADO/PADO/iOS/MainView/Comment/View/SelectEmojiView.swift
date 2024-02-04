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
            Spacer()
            
            if feedVM.selectedEmoji == "Basic" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.white, lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            } else if feedVM.selectedEmoji == "👍" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.green, lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            } else if feedVM.selectedEmoji == "🥰" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.pink, lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            } else if feedVM.selectedEmoji == "🤣" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.yellow, lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            } else if feedVM.selectedEmoji == "😡" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.orange, lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            } else if feedVM.selectedEmoji == "😢" {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.blue, lineWidth: 3.0)
                        .frame(width: 102, height: 102)
                    
                    feedVM.cropMojiImage
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            } else {
                feedVM.cropMojiImage
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            Spacer()
            
            Text("FaceMoji의 이모티콘을 선택해주세요")
                .font(.system(size: 16))
            
        }
        
        VStack(alignment: .center) {
            Spacer()
            
            HStack {
                Button {
                    feedVM.selectedEmoji = "Basic"
                } label: {
                    Text("Basic")
                        .font(.system(size: 30))
                }
                
                Button {
                    feedVM.selectedEmoji = "👍"
                } label: {
                    Text("👍")
                        .font(.system(size: 30))
                }
                
                Button {
                    feedVM.selectedEmoji = "🥰"
                } label: {
                    Text("🥰")
                        .font(.system(size: 30))
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            
            HStack {
                Button {
                    feedVM.selectedEmoji = "🤣"
                } label: {
                    Text("🤣")
                        .font(.system(size: 30))
                }
                
                Button {
                    feedVM.selectedEmoji = "😡"
                } label: {
                    Text("😡")
                        .font(.system(size: 30))
                }
                
                Button {
                    feedVM.selectedEmoji = "😢"
                } label: {
                    Text("😢")
                        .font(.system(size: 30))
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            
            Button {
                feedVM.updateEmoji(emoji: feedVM.selectedEmoji)
            } label: {
                Text("페이스모지 게시")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            .background(.blueButton)
            .cornerRadius(10)
        }
    }
}
