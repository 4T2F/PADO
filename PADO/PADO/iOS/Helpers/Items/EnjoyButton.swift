//
//  EnjoyButton.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct EnjoyButton: View {
    
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1)
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 47)
                .foregroundStyle(.clear)
            
            HStack {
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(.trailing, 80)
                
                Image("Arrow_right_light")
            }
            .frame(height: 30)
        }
    }
}

#Preview {
    EnjoyButton(text: "로그인")
}
