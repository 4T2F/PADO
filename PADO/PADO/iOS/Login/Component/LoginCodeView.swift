//
//  LoginCodeView.swift
//  PADO
//
//  Created by 최동호 on 1/21/24.
//

import SwiftUI

struct LoginCodeView: View {

    @State private var buttonActive: Bool = false
    @State private var otpVerificationFailed = false
    
    @Binding var currentStep: LoginStep
    
    var dismissAction: () -> Void
    
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // 휴대폰 번호 받아와야함
                Text("\(viewModel.phoneNumber) 로 인증번호를 보냈어요")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    VerificationView(otpText: $viewModel.otpText)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .onChange(of: viewModel.otpText) { _, newValue in
                            buttonActive = newValue.count == 6
                            if otpVerificationFailed && newValue.count < 6 {
                                otpVerificationFailed = false
                            }
                        }
                    
                    if otpVerificationFailed {
                        Text("인증 번호가 틀렸습니다")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 20)
                        
                    }
                }
                
                Spacer()
                
                Button {
                    if buttonActive {
                        Task {
                            let verificationResult = await viewModel.verifyOtp()
                            if verificationResult {
                                let isUserExisted = await viewModel.checkPhoneNumberExists(phoneNumber: "+82\(viewModel.phoneNumber)")
                                if isUserExisted {
                                    await viewModel.fetchUIDByPhoneNumber(phoneNumber: "+82\(viewModel.phoneNumber)")
                                    await viewModel.fetchUser()
                                } else {
                                    // 가입되지 않은 번호 -> 회원가입 페이지로 이동하게 구현
                                }
                            } else {
                                otpVerificationFailed = true
                            }
                        }
                    }
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "로그인하기")
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
            
        }
        
    }
}

//#Preview {
//    LoginCodeView()
//}
