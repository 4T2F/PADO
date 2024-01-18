//
//  BlackButtonView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct ModalBlackButton: View {
    
    @Binding var buttonActive: Bool
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                .foregroundStyle(.modalBlackButton)
            HStack {
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
            .frame(height: 30)
        }
    }
}

#Preview {
    ModalBlackButton(buttonActive: .constant(true), text: "시작화면으로 이동")
}
