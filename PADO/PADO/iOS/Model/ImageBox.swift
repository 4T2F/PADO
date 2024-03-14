//
//  ImageBox.swift
//  PADO
//
//  Created by 김명현 on 2/14/24.
//

import SwiftUI

struct ImageBox: Identifiable {
    var id = UUID().uuidString
    var image = Image(systemName: "bolt")
    var size: CGRect = .zero
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var rotation: Angle = .zero
    var lastRotation: Angle = .zero
    var isAdded: Bool = false
}

