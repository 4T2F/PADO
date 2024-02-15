//
//  UseIDModalView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

enum LoginSignUpType {
    case login
    case signUp
}

struct UseIDModalView: View {
    
    @State private var buttonActive: Bool = true
    @Binding var showUseID: Bool
    @Binding var loginSignUpType: LoginSignUpType
    @Binding var currentStep: SignUpStep
    var dismissSignUpView: () -> Void
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        switch loginSignUpType {
        case .login:
            ZStack {
                Color.modal.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 15, content: {
                    Text("가입되지 않은 번호 입니다")
                        .font(.system(size: 24))
                        .fontWeight(.heavy)
                        .padding(.top, 5)
                    
                    VStack(spacing: 20) {
                        Button {
                            loginSignUpType = .signUp
                            currentStep = .id
                            showUseID = false
                        } label: {
                            ModalWhiteButton(buttonActive: $buttonActive,
                                             text: "이 번호로 회원가입하기")
                        }
                        
                        Button {
                            // StartView 이동
                            showUseID = false
                            viewModel.phoneNumber = ""
                            viewModel.otpText = ""
                            dismissSignUpView()
                        } label: {
                            ModalBlackButton(buttonActive: $buttonActive,
                                             text: "시작 화면으로 이동")
                            .presentationDetents([.fraction(0.2)])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(30)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, -25)
                })
                .padding(.vertical, 15)
                .padding(.horizontal, 25)
                .interactiveDismissDisabled()
            }
        case .signUp:
            ZStack {
                Color.modal.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 15, content: {
                    Text("이미 가입된 사용자 입니다")
                        .font(.system(size: 24))
                        .fontWeight(.heavy)
                        .padding(.top, 5)
                    
                    VStack(spacing: 20) {
                        Button {
                            Task {
                                await viewModel.fetchUIDByPhoneNumber(phoneNumber: "+82\(viewModel.phoneNumber)")
                                await viewModel.fetchUser()
                                viewModel.needsDataFetch = true
                            }
                        } label: {
                            ModalWhiteButton(buttonActive: $buttonActive,
                                             text: "로그인 하기")
                        }
                        
                        Button {
                            // StartView 이동
                            showUseID = false
                            viewModel.phoneNumber = ""
                            viewModel.otpText = ""
                            dismissSignUpView()
                        } label: {
                            ModalBlackButton(buttonActive: $buttonActive,
                                             text: "시작 화면으로 이동")
                            .presentationDetents([.fraction(0.2)])
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(30)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, -25)
                })
                .padding(.vertical, 15)
                .padding(.horizontal, 25)
                .interactiveDismissDisabled()
            }
        }
    }

}
