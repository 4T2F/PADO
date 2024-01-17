//
//  CodeView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct CodeView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showUseID: Bool = false
    @State private var buttonActive: Bool = true
    @State private var otpVerificationFailed = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mainBackground.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("PADO")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        
                        HStack {
                            Button {
                                viewModel.otpText = ""
                                showUseID = false
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
                    // 휴대폰 번호 받아와야함
                    Text("\(viewModel.phoneNumber) 로 인증번호를 보냈어요")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VerificationView(otpText: $viewModel.otpText)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        
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
                        Task {
                            let verificationResult = await viewModel.verifyOtp()
                            if verificationResult {
                                let isUserExisted = await viewModel.checkPhoneNumberExists(phoneNumber: "+82\(viewModel.phoneNumber)")
                                if !isUserExisted {
                                    showUseID.toggle()
                                } else {
                                    // IdView로 이동
                                }
                            } else {
                                otpVerificationFailed = true
                            }
                        }
                    } label: {
                            WhiteButtonView(buttonActive: $buttonActive, text: "다음")

                        // true 일 때 버튼 변하게 하는 onChange 로직 추가해야함
                    }
                    .padding(.bottom)
                }
                .padding(.top, 150)
                .sheet(isPresented: $showUseID, content: {
                    UseIDModalView()
                        .presentationDetents([.height(250)])
                        .presentationCornerRadius(30)
                })
                .interactiveDismissDisabled(showUseID)
                
            }
        }
        .navigationBarBackButtonHidden(true)
    
    }
}

//#Preview {
//    CodeView()
//}
