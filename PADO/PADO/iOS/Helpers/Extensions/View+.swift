//
//  View+.swift
//  PADO
//
//  Created by 황성진 on 3/18/24.
//

import SwiftUI

extension View {
    // MARK: - ForImageCrop
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self // 자를때 프레임
            .frame(width: size.width,
                   height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    // MARK: - 세팅셀 모디파이어
    func settingMidCellModi() -> some View {
        self
            .foregroundStyle(.gray)
            .fontWeight(.semibold)
            .font(.system(.footnote))
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
    }
    
    // MARK: - 세팅셀 폰트 모디파이어
    func settingFontModi() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(.body))
            .fontWeight(.semibold)
    }
    
    // MARK: Offset Modifier
    @MainActor
    @ViewBuilder
    func offset(coordinateSpace: String,
                offset: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader{proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}
