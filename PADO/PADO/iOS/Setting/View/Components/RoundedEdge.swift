//
//  RoundedEdge.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

import SwiftUI

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}
