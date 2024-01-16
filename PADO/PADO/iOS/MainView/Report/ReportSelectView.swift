//
//  ReportSelectView.swift
//  PADO
//
//  Created by 김명현 on 1/16/24.
//

import SwiftUI

struct ReportSelectView: View {
    
    @State var reportArray:[String] = ["부적절한 게시물", "부적절한 프로필 사진", "부적절한 사용자 이름", "부적절한 FaceMoji", "사칭", "스팸", "기타"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {

                
                HStack {
                    Spacer()
                    
                    Text("천랑성님 신고하기") // 유저이름 넣기
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    
                    Spacer()
                } //: HStack
                .padding(.bottom, 20)
                
                Text("이 게시물을 신고하는 이유가 궁금해요")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .padding(.bottom, 3)
                    .padding(.leading)
                Text("지식재산권 침해를 신고하는 경우를 제외하고 회원님의 신고는 익명으로 처리\n됩니다. 누군가 위급한 상황에 있다고 생각된다면 즉시 현지응급 서비스 기관\n에 연락하시기 바랍니다.")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .lineSpacing(5)
                    .padding(.horizontal)
                ForEach(reportArray, id: \.self) { reportReason in
                    ReportSelectCellView(text: reportReason)
                        .padding(.bottom, 8)
                }
            } //: VStack
        } //: ZStack
    }
}

#Preview {
    ReportSelectView()
}
