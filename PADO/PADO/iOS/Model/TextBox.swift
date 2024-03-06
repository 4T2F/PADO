//
//  TextBox.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import SwiftUI

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var rotation: Angle = .zero
    var lastRotation: Angle = .zero
    var isAdded: Bool = false
}
