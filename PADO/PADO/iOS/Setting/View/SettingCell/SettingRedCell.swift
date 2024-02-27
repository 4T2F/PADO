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
                .fill(.mainBackground)
                .frame(height: 45)
               
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.red)
                
                Text(text)
                    .foregroundStyle(.red)
                    .font(.system(.body))
                
                Spacer()
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
            .frame(height: 50)
        }
    }
}
