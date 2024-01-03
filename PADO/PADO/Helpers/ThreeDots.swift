//
//  ThreeDots.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct ThreeDots: View {
    
    var size: CGFloat
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(color)
                .font(.system(size: size))
            Image(systemName: "circle.fill")
                .foregroundStyle(color)
                .font(.system(size: size))
                .padding(.leading, -4)
            Image(systemName: "circle.fill")
                .foregroundStyle(color)
                .font(.system(size: size))
                .padding(.leading, -4)
        }
    }
}

#Preview {
    ThreeDots(size: 4, color: .black)
}
