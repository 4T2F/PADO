//
//  SignUpView.swift
//  PADO
//
//  Created by 최동호 on 1/21/24.
//

import SwiftUI

enum SignUpStep {
    case phoneNumber
    case code
    case id
    case birth
    case welcome
}

struct SignUpView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentStep: SignUpStep = .phoneNumber
    @State var loginSignUpType: LoginSignUpType
    var body: some View {
        ZStack {
            switch currentStep {
            case .phoneNumber:
                PhoneNumberView(loginSignUpType: $loginSignUpType,
                                currentStep: $currentStep)
            case .code:
                CodeView(loginSignUpType: $loginSignUpType,
                         currentStep: $currentStep,
                         dismissAction: { dismiss() })
            case .id:
                IdView(currentStep: $currentStep)
            case .birth:
                BirthView(currentStep: $currentStep)
            case .welcome:
                WelcomeView()
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("PADO")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if currentStep != .welcome {
                    Button {
                        handleBackButton()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Text("뒤로")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
    
    func handleBackButton() {
        switch currentStep {
        case .phoneNumber:
            dismiss()
            viewModel.phoneNumber = ""
        case .code:
            currentStep = .phoneNumber
            viewModel.phoneNumber = ""
            viewModel.otpText = ""
        case .id:
            currentStep = .phoneNumber
            viewModel.phoneNumber = ""
            viewModel.otpText = ""
            viewModel.nameID = ""
        case .birth:
            viewModel.nameID = ""
            viewModel.year = ""
            currentStep = .id
        case .welcome:
            dismiss()
        }
    }
}
