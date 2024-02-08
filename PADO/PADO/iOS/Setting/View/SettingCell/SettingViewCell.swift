//
//  SettingViewCell.swift
//  PADO
//
//  Created by 김명현 on 1/29/24.
//

import SwiftUI

struct SettingViewCell: View {
    var settingTittle: String
    
    var body: some View {
        HStack {
            Text("\(settingTittle)")
                .font(.system(size: 14))
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
        .padding(.vertical, -7)
        
    }
}
