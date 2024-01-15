//
//  PhoneNumberView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct PhoneNumberView: View {
    
    @State private var phoneNumber: String = ""
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
                Text("휴대폰 번호")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(hint: "휴대폰 번호를 입력해주세요", value: $phoneNumber)
                        .tint(.white)
                        .keyboardType(.numberPad)
                    
                    Text("Thank you for Signing up the PADO")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    // 다음 뷰로 넘어가는 네비게이션 링크 추가 해야함
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "인증 번호 전송")
                    // true 일 때 버튼 변하게 하는 onChange 로직 추가해야함
                }
                .padding(.bottom)
                
            }
            .padding(.top, 150)
        }
    }
}

#Preview {
    PhoneNumberView()
}
