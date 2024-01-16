//
//  SettingRedCell.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

import SwiftUI

struct SettingRedCell: View {
    
    var icon: String
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 45)
                .opacity(0.04)
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.red)
                
                Text(text)
                    .foregroundStyle(.red)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                
                Spacer()
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
            .frame(height: 50)
        }
    }
}
