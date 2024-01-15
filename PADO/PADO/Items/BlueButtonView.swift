//
//  BlueButtonView.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct BlueButtonView: View {
    
    @Binding var buttonActive: Bool
    let activeText: String
    let unActiveText: String
    let widthValue: CGFloat
    let heightValue: CGFloat
    
    var body: some View {
        Button(action: {
            // 버튼을 터치했을 때 buttonActive 상태를 토글
            buttonActive.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: widthValue, height: heightValue)
                    .foregroundStyle(buttonActive ?  .blueButton : .grayButton )
                
                HStack {
                    buttonActive ?
                    Text(activeText)
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    :
                    Text(unActiveText)
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                }
                .padding(.horizontal)
            }
        }
    }
}

