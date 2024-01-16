//
//  ReportSelectCellView.swift
//  PADO
//
//  Created by 김명현 on 1/16/24.
//

import SwiftUI

struct ReportSelectCellView: View {
    var text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 45)
                .foregroundStyle(Color(.systemGray5))
            HStack {
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
            .frame(height: 30)
        }
    }
}

#Preview {
    ReportSelectCellView(text: "신고하기")
}
