//
//  ReportSelectCellView.swift
//  PADO
//
//  Created by 김명현 on 1/16/24.
//

import SwiftUI

struct ReportSelectCellView: View {
    @Binding var isShowingReportView: Bool
    
    var text: String
    
    var body: some View {
        NavigationLink(destination: ReportResultView(isShowingReportView: $isShowingReportView)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 45)
                    .foregroundStyle(.modalCell)
                HStack {
                    Text(text)
                        .foregroundStyle(.white)
                        .font(.system(.subheadline))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(.subheadline))
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
                .frame(height: 30)
            }
        }
    }
}
