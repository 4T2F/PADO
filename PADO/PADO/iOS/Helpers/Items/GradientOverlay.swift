//
//  GradientOverlay.swift
//  PADO
//
//  Created by 강치우 on 3/17/24.
//

import SwiftUI

struct GradientOverlay: View {
    @Binding var isHeaderVisible: Bool
    
    var body: some View {
        if isHeaderVisible {
            LinearGradient(colors: [.black.opacity(0.5),
                                    .black.opacity(0.4),
                                    .black.opacity(0.3),
                                    .black.opacity(0.2),
                                    .black.opacity(0.1),
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .clear, .clear,
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3),
                                    .black.opacity(0.4),
                                    .black.opacity(0.5)],
                           startPoint: .top,
                           endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
