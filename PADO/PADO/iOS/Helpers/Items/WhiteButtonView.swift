//
//  WhiteButtonView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct WhiteButtonView: View {
    
    @Binding var buttonActive: Bool
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                .foregroundStyle(buttonActive ? Color(red: 250/255, green: 250/255, blue: 250/255) : Color.grayButton)
            
            HStack {
                
                Text(text)
                    .foregroundStyle(.black)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                
                Spacer()
                
                Image("Arrow_right_dark")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
            .frame(height: 30)
        }
    }
}

#Preview {
    WhiteButtonView(buttonActive: .constant(true), text: "로그인 하기")
}
