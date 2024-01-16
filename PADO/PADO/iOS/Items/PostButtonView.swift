//
//  PostButtonView.swift
//  PADO
//
//  Created by 황민채 on 1/17/24.
//

import SwiftUI

struct PostButtonView: View {
    var postX: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * postX, height: 47)
                .foregroundStyle(.blueButton)
            
            HStack {
                Text("게시요청")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(.trailing, 90)
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .frame(height: 30)
        }
    }
}

//#Preview {
//    PostButtonView()
//}
