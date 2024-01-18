//
//  SignUpButton.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct SignUpButton: View {
    
//    @Binding var buttonActive: Bool
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.3, height: 47)
                .foregroundStyle(Color(red: 250/255, green: 250/255, blue: 250/255))
            
            HStack {
                
                Text(text)
                    .foregroundStyle(.black)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .padding(.trailing, 6)
                
                Image(systemName: "person")
                    .foregroundStyle(.black)
                    .font(.system(size: 17))
                    .fontWeight(.regular)
            }
            .frame(height: 30)
        }
    }
}

#Preview {
    SignUpButton(text: "Sign Up")
}
