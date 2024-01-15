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
            Color.mainBackground.ignoresSafeArea()
            VStack {
                ZStack {
                    Text("PADO")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
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
                    // 다음 뷰로 넘어가는 네비게이션 링크 추가 해야함
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "다음")
                    // true 일 때 버튼 변하게 하는 onChange 로직 추가해야함
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
        }
    }
}

#Preview {
    IdView()
}
