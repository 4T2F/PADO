//
//  SettingProfileDevider.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//
import SwiftUI

struct SettingProfileDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.7)
            .foregroundStyle(.gray)
            .opacity(0.3)
    }
}

struct SettingDivider: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: UIScreen.main.bounds.width * 0.93, height: 0.5)
            .foregroundStyle(Color(UIColor.systemGray3))
            .padding(.horizontal)
            .padding(.vertical)
    }
        
}
