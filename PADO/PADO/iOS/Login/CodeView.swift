//
//  CodeView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct CodeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var otpText = ""
    @State private var buttonActive: Bool = false
    
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
                Text("010-1111-1111 로 인증번호를 보냈어요")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    VerificationView(otpText: $otpText)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    // 인증 번호 틀렸을 때 나오게 하는 로직 추가 해야함
                    Text("인증 번호가 틀렸습니다")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 20)
                }
                
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
    CodeView()
}
