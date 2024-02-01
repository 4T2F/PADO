//
//  FaceMojiCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

enum Emotion: String, CaseIterable {
    case basic = ""
    case thumbsUp = "👍"
    case heart = "🥰"
    case laughing = "🤣"
    case angry = "😡"
    case sad = "😢"
    case overEat = "🤮"
    
    var emoji: String {
        self.rawValue
    }
    
    var color: Color {
        switch self {
        case .basic:
            return .white
        case .thumbsUp:
            return .green
        case .heart:
            return .pink
        case .laughing:
            return .yellow
        case .angry:
            return .orange
        case .sad:
            return .blue
        case .overEat:
            return .purple
        }
    }
}

struct FaceMojiCell: View {
    let emotion: Emotion
    let faceMojiUser: String
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(emotion.color)
                
                Image("pp")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
                
                Text(emotion.emoji)
                    .offset(x: 22, y: 20)
            }
            
            Text(faceMojiUser)
                .foregroundStyle(.white)
                .font(.system(size: 10))
                .fontWeight(.medium)
        }
    }
}

#Preview {
    FaceMojiCell(emotion: .heart, faceMojiUser: "DogStar")
}
