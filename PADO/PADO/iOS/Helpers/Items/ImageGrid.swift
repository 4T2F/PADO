//
//  ImageGrid.swift
//  PADO
//
//  Created by 황성진 on 3/18/24.
//

// MARK: - Crop 관련 격자를 보여주는 뷰

import SwiftUI

struct ImageGrid: View {
    var isShowinRectangele: Bool
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(1...2, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(1...3, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
            
            if isShowinRectangele {
                RoundedRectangle(cornerRadius: 150)
                    .stroke(.white, lineWidth: 2)
                    .foregroundStyle(.clear)
            }
        }
    }
}
