//
//  SettingToggleCell.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingToggleCell: View {
    var icon: String
    var text: String
    
    @Binding var toggle: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.mainBackground)
                .frame(height: 45)
                
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.white)
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(.subheadline))
                    .fontWeight(.medium)
                
                Spacer()
                
                Toggle("", isOn: $toggle)
                    .tint(.green)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
            .frame(height: 30)
        }
    }
}
