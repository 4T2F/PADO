//
//  SNSButton.swift
//  PADO
//
//  Created by 강치우 on 1/31/24.
//

import SwiftUI

struct SNSButton: View {
    
    @Binding var buttonActive: Bool
    var text: String
    var image: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.7), lineWidth: 1)
                .foregroundStyle(.clear)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
            
            HStack {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                Spacer()
                
                Image("Arrow_right_light")
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
            .frame(height: 30)
        }
    }
}

#Preview {
    SNSButton(buttonActive: .constant(true), text: "Instagram", image: "instagram")
}
