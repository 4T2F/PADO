//
//  ModalWhiteButton.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct ModalWhiteButton: View {
    
    @Binding var buttonActive: Bool
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                .foregroundStyle(Color(red: 250/255, green: 250/255, blue: 250/255))
            
            HStack {
                
                Text(text)
                    .foregroundStyle(.black)
                    .font(.system(.body))
                    .fontWeight(.medium)
                
                Spacer()
                
                Image("Arrow_right_dark")
                    .font(.system(.body))
                    .fontWeight(.medium)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
            .frame(height: 30)
        }
    }
}

#Preview {
    ModalWhiteButton(buttonActive: .constant(true), text: "로그인 하기")
}

