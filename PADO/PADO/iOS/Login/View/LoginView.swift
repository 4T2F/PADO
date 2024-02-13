////
////  LoginView.swift
////  PADO
////
////  Created by 최동호 on 1/21/24.
////
//
//import SwiftUI
//
//enum LoginStep {
//    case phoneNumber
//    case code
//}
//
//struct LoginView: View {
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//    @Environment(\.dismiss) var dismiss
//    @State var currentStep: LoginStep = .phoneNumber
//    
//    var body: some View {
//        
//        ZStack {
//            switch currentStep {
//            case .phoneNumber:
//                LoginPhoneNumberView(currentStep: $currentStep)
//            case .code:
//                LoginCodeView(currentStep: $currentStep,
//                         dismissAction: { dismiss() })
//            }
//        }
//        .background(.main, ignoresSafeAreaEdges: .all)
//        .navigationBarBackButtonHidden()
//        .navigationTitle("PADO")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    HStack(spacing: 2) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 14))
//                            .fontWeight(.medium)
//                        
//                        Text("뒤로")
//                            .font(.system(size: 16))
//                            .fontWeight(.medium)
//                    }
//                    .foregroundStyle(.white)
//                }
//            }
//        }
//        .toolbarBackground(Color(.main), for: .navigationBar)
//    }
//    
//    func handleBackButton() {
//        switch currentStep {
//        case .phoneNumber:
//            dismiss()
//            viewModel.phoneNumber = ""
//        case .code:
//            currentStep = .phoneNumber
//            viewModel.phoneNumber = ""
//            viewModel.otpText = ""
//
//        }
//    }
//}
