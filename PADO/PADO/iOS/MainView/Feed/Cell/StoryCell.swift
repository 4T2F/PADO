//
//  StoryCell.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct StoryCell: View {
    
    var story: Story
    var onTap: () -> Void  // 탭 동작을 위한 클로저
    
    var body: some View {
        VStack {
            Image(story.image)
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(70)
            Text(story.name)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        .onTapGesture {
            onTap()  // 텍스트를 탭했을 때 클로저 호출
        }
    }
}
