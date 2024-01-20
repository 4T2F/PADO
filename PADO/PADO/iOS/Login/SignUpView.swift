//
//  SignUpView.swift
//  PADO
//
//  Created by 최동호 on 1/21/24.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
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
                            viewModel.phoneNumber = ""
                            dismiss()
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
            
            PhoneNumberView(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView(viewModel: MainView().viewModel)
}
