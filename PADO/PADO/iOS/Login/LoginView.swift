//
//  LoginView.swift
//  PADO
//
//  Created by 최동호 on 1/21/24.
//

import SwiftUI

enum LoginStep {
    case phoneNumber
    case code
}

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentStep: LoginStep = .phoneNumber
    
    var body: some View {
        
        ZStack {
            Color.mainBackground.ignoresSafeArea()
            VStack {
                ZStack {
                    Text("PADO")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            handleBackButton()
                        } label: {
                            Image("dismissArrow")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            switch currentStep {
            case .phoneNumber:
                LoginPhoneNumberView(currentStep: $currentStep,
                                viewModel: viewModel)
            case .code:
                LoginCodeView(currentStep: $currentStep,
                         dismissAction: { dismiss() },
                         viewModel: viewModel)
           
            }
        }
        .navigationBarBackButtonHidden(true)
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

        }
    }
}
//
//#Preview {
//    LoginView()
//}
