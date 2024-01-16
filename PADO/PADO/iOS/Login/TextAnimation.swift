//
//  TextAnimation.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct TextAnimation: Identifiable {
    var id = UUID().uuidString
    var text: String
    var offset: CGFloat = 110
}
