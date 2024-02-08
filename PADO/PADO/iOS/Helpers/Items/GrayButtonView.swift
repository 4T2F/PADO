//
//  GrayButtonView.swift
//  PADO
//
//  Created by 황민채 on 1/17/24.
//

import SwiftUI

struct GrayButtonView: View {
    
    var text: String
    var grayButtonX: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * grayButtonX, height: 45)
                .foregroundStyle(.grayButton)
            
            HStack {
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .frame(height: 30)
        }
    }
}
