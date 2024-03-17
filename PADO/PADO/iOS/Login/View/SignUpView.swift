//
//  SignUpView.swift
//  PADO
//
//  Created by 최동호 on 1/21/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var loginVM: LoginViewModel

    @State var loginSignUpType: LoginSignUpType
    
    @Binding var isShowStartView: Bool
    
    var body: some View {
        ZStack {
            switch loginVM.currentStep {
            case .phoneNumber:
                PhoneNumberView(loginVM: loginVM,
                                loginSignUpType: $loginSignUpType)
            case .code:
                CodeView(loginVM: loginVM,
                         loginSignUpType: $loginSignUpType,
                         isShowStartView: $isShowStartView,
                         dismissAction: { dismiss() })
            case .id:
                IdView(loginVM: loginVM)
            case .birth:
                BirthView(loginVM: loginVM,
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
                    loginVM.handleBackButton(dismiss: { dismiss() })
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
    
    
}
