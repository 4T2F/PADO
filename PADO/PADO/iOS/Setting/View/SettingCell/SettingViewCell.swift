//
//  SettingViewCell.swift
//  PADO
//
//  Created by 김명현 on 1/29/24.
//

import SwiftUI

struct SettingViewCell: View {
    @State var settingTittle: String
    
    var body: some View {
        HStack {
            Text("\(settingTittle)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.gray)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, -7)
    }
}
