//
//  PhoneNumberView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct PhoneNumberView: View {
    
    @State var buttonActive: Bool = false
    var tfFormat = PhoneumberTFFormat()
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
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
            
            VStack(alignment: .leading) {
                Text("휴대폰 번호")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(hint: "휴대폰 번호를 입력해주세요", value: $viewModel.phoneNumber)
                        .onChange(of: viewModel.phoneNumber) { newValue, _ in
                            let formattedNumber = tfFormat.formatPhoneNumber(newValue)
                            viewModel.phoneNumber = formattedNumber
                            buttonActive = formattedNumber.count == 12 || formattedNumber.count == 13
                        }
                        .tint(.white)
                        .keyboardType(.numberPad)
                    
                    Text("Thank you for Signing up the PADO")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
                Spacer()
                NavigationLink(destination: CodeView()) {
                    WhiteButtonView(buttonActive: $buttonActive, text: "인증 번호 전송")
                }
                .simultaneousGesture(TapGesture().onEnded {
                    if buttonActive {
                        Task {
                            await viewModel.sendOtp()
                        }
                    }
                })
                .padding(.bottom)
                
            }
            .padding(.top, 150)
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    PhoneNumberView()
//}
