//
//  PhoneNumberView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct PhoneNumberView: View {
    
    @State private var phoneNumber: String = ""
    @State var buttonActive: Bool = true
    
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
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                VStack(alignment: .leading, spacing: 25) {
                    CustomTF(hint: "휴대폰 번호를 입력해주세요", value: $phoneNumber)
                        .tint(.white)
                    
                    Text("Thank you for Signing up the PADO")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "인증 번호 전송")
                }
                
            }
            .padding(.top, 150)
        }
    }
}

#Preview {
    PhoneNumberView()
}
