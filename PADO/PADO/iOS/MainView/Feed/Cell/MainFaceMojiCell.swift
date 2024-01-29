//
//  MainFaceMojiCell.swift
//  PADO
//
//  Created by 황민채 on 1/23/24.
//
import SwiftUI

struct MainFaceMojiCell: View {
    let mainFaceMoji: MainFaceMoji
    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .frame(width: 54, height: 54)
                    .foregroundStyle(mainFaceMoji.emotion.color)
                
                Image(mainFaceMoji.emotionPhoto)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                Text(mainFaceMoji.emotion.emoji)
                    .offset(x: 22, y: 20)
            }
        }
    }
}

