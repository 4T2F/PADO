//
//  ReportResultView.swift
//  PADO
//
//  Created by 김명현 on 1/16/24.
//

import SwiftUI

struct ReportResultView: View {
    @Binding var isShowingReportView: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "megaphone")
                .resizable()
                .fontWeight(.regular)
                .frame(width: 35, height: 35)
                .foregroundStyle(Color(.systemBlue))
                .padding(.bottom, 20)
            
            Text("신고가 접수되었습니다")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            
            Text("신고 용도 :")
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                    
                    Text("사람들이 PADO에서 다양한 유형의 콘텐츠로 인해 겪고 있는 문제를 이해합니다.")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .padding(.trailing, 15)
                        .lineSpacing(5)
                } //: HStack
                .padding(.bottom, 30)
                
                HStack {
                    Image(systemName: "eye.slash")
                        .resizable()
                        .frame(width: 25, height: 20)
                        .bold()
                        .padding(.horizontal)
                    Text("앞으로 이 유형의 콘텐츠를 더 적게 표시합니다.")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                } //: HStack
            }
            
            Spacer()
            
            Button {
                isShowingReportView = false
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .foregroundStyle(.blueButton)
                    
                    Text("확인")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
            }
        } //: VStack
        .padding(.vertical)
        .padding(.top)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ReportResultView(isShowingReportView: .constant(false))
}
