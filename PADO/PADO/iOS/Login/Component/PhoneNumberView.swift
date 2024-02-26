//
//  PhoneNumberView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct PhoneNumberView: View {
    
    var tfFormat = PhoneumberTFFormat()
    
    @State var buttonActive: Bool = false
    @Binding var loginSignUpType: LoginSignUpType
    @Binding var currentStep: SignUpStep
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                Text("휴대폰 번호")
                    .font(.system(.title2))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(hint: "휴대폰 번호를 입력해주세요", value: $viewModel.phoneNumber)
                        .onChange(of: viewModel.phoneNumber) { _, newValue in
                            let formattedNumber = tfFormat.formatPhoneNumber(newValue)
                            viewModel.phoneNumber = formattedNumber
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
                            await viewModel.sendOtp()
                            currentStep = .code
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
