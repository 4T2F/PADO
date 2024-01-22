//
//  FaceMoji.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct FaceMojiView: View {
    let emotions: [Emotion] = Emotion.allCases
    let users: [String] = ["DogStar", "Hsunjin", "pinkSo"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(zip(emotions, users)), id: \.0.self) { (emotion, user) in
                        FaceMojiCell(emotion: emotion, faceMojiUser: user)
                            .padding(.horizontal, 6)
                }
                Button {
                    // 페이스모지 열기
                } label: {
                    VStack {
                        Image("plusFaceMoji")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                     
                        Text("")
                            
                    }
                }
                .padding(.horizontal)

            }
        }
    }
}

#Preview {
    FaceMojiView()
}
