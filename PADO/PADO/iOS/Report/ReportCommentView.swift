//
//  reportCommentView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import SwiftUI

struct ReportCommentView: View {
    // MARK: - PROPERTY
    @State var reportArray: [String] = ["부적절한 댓글", "사칭", "스팸", "기타"]
    @Binding var isShowingReportView: Bool
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("신고하기")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(.top, 30)
                    
                    Divider()
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                  
                        Text("댓글을 신고하는 이유가 무엇인가요?")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(.bottom, 3)
                            .padding(.horizontal)
                        
                        Text("지식재산권 침해를 신고하는 경우를 제외하고 회원님의 신고는\n익명으로 처리됩니다.")
                            .font(.system(.footnote))
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .lineSpacing(3)
                            .padding(.bottom)
                            .padding(.horizontal)
                             
                        VStack {
                            ForEach(reportArray, id: \.self) { reportReason in
                                ReportSelectCellView(isShowingReportView: $isShowingReportView, text: reportReason)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .background(.modal, ignoresSafeAreaEdges: .all)
        }
    }
}
