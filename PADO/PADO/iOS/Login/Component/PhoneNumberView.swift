//
//  PhoneNumberView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct PhoneNumberView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var loginVM: LoginViewModel
    
    @State var buttonActive: Bool = false
    
    @Binding var loginSignUpType: LoginSignUpType
    
    var tfFormat = PhoneumberTFFormat()
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                Text("휴대폰 번호")
                    .font(.system(.title2))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(value: $loginVM.phoneNumber,
                             hint: "휴대폰 번호를 입력해주세요")
                    .onChange(of: loginVM.phoneNumber) { _, newValue in
                            let formattedNumber = tfFormat.formatPhoneNumber(newValue)
                            loginVM.phoneNumber = formattedNumber
                            buttonActive = formattedNumber.count == 12 || formattedNumber.count == 13
                        }
                        .tint(.white)
                        .keyboardType(.numberPad)
                    
                    Text(loginSignUpType == .signUp ?
                         "Thank you for Signing up the PADO" :
                        "Welcome back to PADO")
                        .font(.system(.subheadline))
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
                Spacer()
                Button {
                    if buttonActive {
                        Task {
                            await loginVM.sendOtp()
                            loginVM.currentStep = .code
                        }
                    }
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "인증 번호 전송")
                }
                .padding(.bottom)
                
            }
            .padding(.top, 150)
        }
    }
}
