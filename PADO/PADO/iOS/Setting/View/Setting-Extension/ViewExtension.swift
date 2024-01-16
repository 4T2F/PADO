//
//  ViewExtension.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

import SwiftUI

//MARK: - 세팅셀 모디파이어
extension View {
    func settingMidCellModi() -> some View {
        self
            .foregroundStyle(.gray)
            .fontWeight(.semibold)
            .font(.system(size: 12))
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
    }
}

//MARK: - 세팅셀 폰트 모디파이어
extension View {
    func settingFontModi() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 16))
            .fontWeight(.semibold)
    }
}
