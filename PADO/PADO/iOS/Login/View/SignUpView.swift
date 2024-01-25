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
                PhoneNumberView(currentStep: $currentStep)
            case .code:
                CodeView(currentStep: $currentStep,
                         dismissAction: { dismiss() })
            case .id:
                IdView(currentStep: $currentStep)
            case .birth:
                BirthView(currentStep: $currentStep)
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
        case .id:
            currentStep = .phoneNumber
            viewModel.phoneNumber = ""
            viewModel.otpText = ""
            viewModel.userID = ""
        case .birth:
            currentStep = .id
            
        }
    }
}
