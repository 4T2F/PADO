//
//  EnjoyButton.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct EnjoyButton: View {
    
    @Binding var buttonActive: Bool
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 47)
                .foregroundStyle(.white)
            
            HStack {
                
                Text(text)
                    .foregroundStyle(.black)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(.trailing, 90)
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.black)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .frame(height: 30)
        }
    }
}

#Preview {
    EnjoyButton(buttonActive: .constant(true), text: "둘러보기")
}
