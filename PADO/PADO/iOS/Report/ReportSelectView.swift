//
//  ReportSelectView.swift
//  PADO
//
//  Created by 김명현 on 1/16/24.
//

import SwiftUI

struct ReportSelectView: View {
    
    @State var reportArray:[String] = ["부적절한 게시물", "부적절한 프로필 사진", "부적절한 사용자 이름", "부적절한 FaceMoji", "사칭", "스팸", "기타"]
    @Binding var isShowingReportView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("신고하기")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            
                            Text("이 게시물을 신고하는 이유")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .padding(.bottom, 3)
                            
                            Text("지식재산권 침해를 신고하는 경우를 제외하고 회원님의 신고는\n익명으로 처리됩니다.")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                                .lineSpacing(3)
                        }
                        .padding(.bottom)
                        .padding(.leading)
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(reportArray, id: \.self) { reportReason in
                                    ReportSelectCellView(isShowingReportView: $isShowingReportView, text: reportReason)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 30)
            }
        }
    }
}

