//
//  NotificationsButtonView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct NotificationsButtonView: View {
    
    var icon: String
    var text: String
    
    @Binding var toggle: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 45)
                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.white)
                
                Text(text)
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .font(.system(size: 14))
                
                Spacer()
                
                Toggle("", isOn: $toggle)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
            .frame(height: 30)
        }
    }
}

#Preview {
    NotificationsButtonView(icon: "face.smiling", text: "RealMojis", toggle: .constant(true))
}
