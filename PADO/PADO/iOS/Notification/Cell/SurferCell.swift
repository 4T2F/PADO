//
//  ReportCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct SurferCell: View {
    
    @State private var buttonActive: Bool = false
    @State var name = ""
    @State var day: Int
    
    var body: some View {
        HStack {
            Image("pp")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(60/2)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(name)님이 회원님을 서퍼로 지정했습니다.")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    +
                    // 시간 로직 추가해야함
                    Text(" \(day)일")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(.systemGray))
                }
            }
            
            Spacer()
        }
        .padding(.leading)
    }
}

#Preview {
    SurferCell(name: "Hsungjin", day: 3)
}
