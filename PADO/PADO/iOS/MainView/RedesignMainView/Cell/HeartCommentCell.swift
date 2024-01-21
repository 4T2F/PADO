//
//  SelectCell.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct HeartCommentCell: View {
    @State var heartOnOff: Bool = false
    @State var isShowingReportView = false
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Button {
                    heartOnOff.toggle()
                } label: {
                    if heartOnOff {
                        Image("Heart_fill")
                    } else {
                        Image("Heart")
                    }
                }
                
                Text("2032")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
            
            VStack {
                Button {
                    // chat func
                } label: {
                    Image("Chat")
                }
                
                Text("13")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
            
            VStack {
                Button {
                    isShowingReportView.toggle()
                } label: {
                    Text("...")
                        .font(.system(size: 32))
                        .fontWeight(.light)
                        .foregroundStyle(.white)
                }
                .sheet(isPresented: $isShowingReportView) {
                    ReportSelectView(isShowingReportView: $isShowingReportView)
                        .presentationDetents([.height(500)]) // 모달높이 조절
                }
            }
            .padding(.top, -15)
        }
    }
}

#Preview {
    HeartCommentCell()
}
