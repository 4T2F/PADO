//
//  CodeView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct CodeView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @ObservedObject var loginVM: LoginViewModel
    
    @State private var showUseID: Bool = false
    @State private var buttonActive: Bool = false
    @State private var otpVerificationFailed = false
    
    @Binding var loginSignUpType: LoginSignUpType
    @Binding var isShowStartView: Bool
    
    var dismissAction: () -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // 휴대폰 번호 받아와야함
                Text("\(loginVM.phoneNumber) 로 인증번호를 보냈어요")
                    .font(.system(.title3))
                    .fontWeight(.medium)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    VerificationView(otpText: $loginVM.otpText)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .onChange(of: loginVM.otpText) { _, newValue in
                            buttonActive = newValue.count == 6
                            if otpVerificationFailed && newValue.count < 6 {
                                otpVerificationFailed = false
                            }
                        }
                    if otpVerificationFailed {
                        Text("인증 번호가 틀렸습니다")
                            .font(.system(.subheadline))
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
                                let verificationResult = await loginVM.verifyOtp()
                                if verificationResult {
                                    let isUserExisted = await loginVM.checkPhoneNumberExists(phoneNumber: "+82\(loginVM.phoneNumber)")
                                    if isUserExisted {
                                        await viewModel.fetchUIDByPhoneNumber(phoneNumber: "+82\(loginVM.phoneNumber)")
                                        await viewModel.fetchUser()
                                        needsDataFetch.toggle()
                                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                                            isShowStartView = false
                                        }
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
                                let verificationResult = await loginVM.verifyOtp()
                                if verificationResult {
                                    let isUserExisted = await loginVM.checkPhoneNumberExists(phoneNumber: "+82\(loginVM.phoneNumber)")
                                    if isUserExisted {
                                        showUseID.toggle()
                                    } else {
                                        loginVM.currentStep = .id
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
                UseIDModalView(loginVM: loginVM,
                               showUseID: $showUseID,
                               loginSignUpType: $loginSignUpType,
                               isShowStartView: $isShowStartView,
                               dismissSignUpView: dismissAction)
                    .presentationDetents([.height(250)])
                    .presentationCornerRadius(30)
            })
            .interactiveDismissDisabled(showUseID)
            
        }
        
    }
}
