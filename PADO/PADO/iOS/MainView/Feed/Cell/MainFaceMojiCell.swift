//
//  MainFaceMojiCell.swift
//  PADO
//
//  Created by 황민채 on 1/23/24.
//
import SwiftUI

struct MainFaceMojiCell: View {
    let mainFaceMoji: MainFaceMoji
    
    @State private var isDragging = false
    
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
        .scaleEffect(isDragging ? 1.1 : 1.0) // 드래그 중이면 크기를 1.1로, 아니면 1.0으로 설정
        .gesture(
            DragGesture()
                .onChanged { _ in
                    isDragging = true
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
        .animation(.easeInOut, value: isDragging) // 드래그 상태 변화에 따른 애니메이션 적용
        
    }
}

// #Preview {
//     MainFaceMojiCell(mainFaceMoji: MainFaceMoji(emotionPhoto: "pp", emotion: .heart))
// }

