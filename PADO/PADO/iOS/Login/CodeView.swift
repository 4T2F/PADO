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
    
    @Binding var currentStep: SignUpStep
    
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
                            
                        }
                    
                    if otpVerificationFailed {
                        Text("인증 번호가 틀렸습니다")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 20)
                        // otpText 수가 줄어들면 다시 사라져야함
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
                                    showUseID.toggle()
                                } else {
                                    currentStep = .id
                                }
                            } else {
                                otpVerificationFailed = true
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
                               dismissSignUpView: dismissAction,
                               viewModel: viewModel)
                    .presentationDetents([.height(250)])
                    .presentationCornerRadius(30)
            })
            .interactiveDismissDisabled(showUseID)
            
        }
        
    }
}

//#Preview {
//    CodeView()
//}
