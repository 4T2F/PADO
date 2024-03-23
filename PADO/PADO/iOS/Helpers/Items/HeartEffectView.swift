//
//  HeartEffectView.swift
//  PADO
//
//  Created by 최동호 on 3/18/24.
//

import SwiftUI

struct HeartEffectView: View {
    var hearts: [Heart]
    
    var body: some View {
        ZStack {
            ForEach(hearts) { heart in
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: heart.size))
                    .foregroundStyle(.red.gradient)
                
                    .animation(.smooth, body: { view in
                        view
                            .scaleEffect(heart.isAnimated ? 1.0 : 2.5)
                            .rotationEffect(.init(degrees: heart.isAnimated ? 0 : .random(in: -90...90)))
                            .opacity(heart.isAnimated ? 0 : 10.0)
                    })
                    .offset(x: heart.tappedRect.x - 50, y: heart.tappedRect.y - 50)
                    .offset(y: heart.isAnimated ? -(heart.tappedRect.y) : 0)
            }
        }
    }
}
