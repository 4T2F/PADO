//
//  TodayHeartCommentCell.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct TodayHeartCommentCell: View {
    @State var heartOnOff: Bool = false
    
    @Binding var isShowingReportView: Bool
    @Binding var isShowingCommentView: Bool
    
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
                    isShowingCommentView.toggle()
                } label: {
                    Image("Chat")
                }
                .sheet(isPresented: $isShowingCommentView) {
                    CommentView()
                        .presentationDetents([.fraction(0.99), .fraction(0.8)])
                        .presentationDragIndicator(.visible)
                }
                
                Text("13")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
            }
            
            VStack {
                Button {
                    isShowingReportView.toggle()
                } label: {
                    VStack {
                        Text("...")
                            .font(.system(size: 32))
                            .fontWeight(.light)
                            .foregroundStyle(.white)
                        
                        Text("")
                    }
                }
                .sheet(isPresented: $isShowingReportView) {
                    ReportSelectView(isShowingReportView: $isShowingReportView)
                        .presentationDetents([.medium, .fraction(0.8)]) // 모달높이 조절
                        .presentationDragIndicator(.visible)
                }
            }
            .padding(.top, -15)
        }
    }
}

#Preview {
    TodayHeartCommentCell(isShowingReportView: .constant(false), isShowingCommentView: .constant(false))
}
