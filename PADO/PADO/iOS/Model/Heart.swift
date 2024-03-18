//
//  HeartEffect.swift
//  PADO
//
//  Created by 최동호 on 3/18/24.
//

import SwiftUI

// 하트 이미지 모델
struct Heart: Identifiable {
    var id: UUID = .init()
    var tappedRect: CGPoint = .zero
    var isAnimated: Bool = false
    var size: CGFloat = 0
}
