//
//  CodeView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct CodeView: View {
    
    @State private var showUseID: Bool = false
    @State private var buttonActive: Bool = false
    @State private var otpVerificationFailed = false
    
    @Binding var loginSignUpType: LoginSignUpType
    @Binding var currentStep: SignUpStep
    
    var dismissAction: () -> Void
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
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
                    switch loginSignUpType {
                    case .login:
                        if buttonActive {
                            Task {
                                let verificationResult = await viewModel.verifyOtp()
                                if verificationResult {
                                    let isUserExisted = await viewModel.checkPhoneNumberExists(phoneNumber: "+82\(viewModel.phoneNumber)")
                                    if isUserExisted {
                                        await viewModel.fetchUIDByPhoneNumber(phoneNumber: "+82\(viewModel.phoneNumber)")
                                        await viewModel.fetchUser()
                                        viewModel.needsDataFetch = true
                                    } else {
                                        showUseID.toggle()
                                    }
                                } else {
                                    otpVerificationFailed = true
                                }
                            }
                        }
                    case .signUp:
                        if buttonActive {
                            Task {
                                let verificationResult = await viewModel.verifyOtp()
                                if verificationResult {
                                    let isUserExisted = await viewModel.checkPhoneNumberExists(phoneNumber: "+82\(viewModel.phoneNumber)")
                                    if isUserExisted {
                                        showUseID.toggle()
                                    } else {
                                        currentStep = .id
                                    }
                                } else {
                                    otpVerificationFailed = true
                                }
                            }
                        }
                    }
                    
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "다음으로")
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
            .sheet(isPresented: $showUseID, content: {
                UseIDModalView(showUseID: $showUseID,
                               loginSignUpType: $loginSignUpType,
                               currentStep: $currentStep,
                               dismissSignUpView: dismissAction)
                    .presentationDetents([.height(250)])
                    .presentationCornerRadius(30)
            })
            .interactiveDismissDisabled(showUseID)
            
        }
        
    }
}
