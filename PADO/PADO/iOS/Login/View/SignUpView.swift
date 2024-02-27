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
}

struct SignUpView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentStep: SignUpStep = .phoneNumber
    @State var loginSignUpType: LoginSignUpType
    @Binding var isShowStartView: Bool
    var body: some View {
        ZStack {
            switch currentStep {
            case .phoneNumber:
                PhoneNumberView(loginSignUpType: $loginSignUpType,
                                currentStep: $currentStep)
            case .code:
                CodeView(loginSignUpType: $loginSignUpType,
                         currentStep: $currentStep,
                         isShowStartView: $isShowStartView,
                         dismissAction: { dismiss() })
            case .id:
                IdView(currentStep: $currentStep)
            case .birth:
                BirthView(currentStep: $currentStep,
                          isShowStartView: $isShowStartView)
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("PADO")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    handleBackButton()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(.body))
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(.white)
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
        }
    }
}
