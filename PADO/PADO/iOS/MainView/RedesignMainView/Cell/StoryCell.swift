//
//  StoryCell.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct StoryCell: View {
    
    var story: Story
    
    var body: some View {
        VStack {
            // 일단은 버튼으로 만들어놨는데 인스타 같은 경우는 버튼이 아닌거 같음 뭔지 나중에 찾아봐야할듯? 아닌가 그냥 버튼으로 해도되나?
            Button {
                
            } label: {
                Image(story.image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(70)
            }
            
            Text(story.name)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        
    }
}

#Preview {
    StoryCell(story: Story(name: "sirius", image: "pp"))
}
