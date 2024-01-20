//
//  IdView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct IdView: View {
    
    @State private var useId: String = ""
    @State var buttonActive: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
    
            
            VStack(alignment: .leading) {
                Text("파도에서 사용할 아이디를 입력해주세요")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(hint: "ID를 입력해주세요", value: $useId)
                        .tint(.white)
                    VStack(alignment: .leading) {
                        Text("영어 대, 소문자, 숫자, 특수문자만 입력 가능해요")
                        
                        Text("한 번 설정한 ID는 수정 불가능해요")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                
                Button {
                    
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "다음으로")
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
        }

    }
}
//
//#Preview {
//    IdView()
//}
