//
//  EnterCodeView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI
import Combine

struct EnterCodeView: View {
    
    @State var buttonActive = false
    
    @State var timeRemaining = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("PADO.")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack {
                        VStack(alignment: .center, spacing: 8) {
                            Text("+\(viewModel.country.phoneCode) \(viewModel.phoneNumber)로 인증 코드를 보냈어요")
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                            
                            Text("......")
                                .foregroundStyle(viewModel.otpText.isEmpty ? .gray : .black)
                                .opacity(0.8)
                                .font(.system(size: 70))
                                .padding(.top, -40)
                                .overlay {
                                    TextField("", text: $viewModel.otpText)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 24))
                                        .fontWeight(.heavy)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(viewModel.otpText), perform: { _ in
                                            limitText(6)
                                        })
                                        .onReceive(Just(viewModel.otpText), perform: { newValue in
                                            let filtered = newValue.filter({
                                                Set("0123456789").contains($0)})
                                            
                                            if filtered != newValue {
                                                viewModel.otpText = filtered
                                            }
                                        })
                                }
                        }
                        .padding(.top, 50)
                        
                        Spacer()
                    }
                    
                    VStack {
                            Text("인증 번호를 입력해주세요")
                                .foregroundStyle(.gray)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        
                        Button {
                            if buttonActive {
                                Task {
                                    await self.viewModel.verifyOtp()
                                }
                            }
                        } label: {
                            WhiteButtonView(buttonActive: $buttonActive, text: viewModel.otpText.count == 6 ? "계속하기" : "재전송 까지 \(timeRemaining)초" )
                        }
                        .disabled(buttonActive ? false : true)
                        .onChange(of: viewModel.otpText) { oldValue, newValue in
                            if !newValue.isEmpty {
                                buttonActive = true
                            } else if newValue.isEmpty {
                                buttonActive = false
                            }
                        }
                    }
                }
            }
            .onReceive(timer, perform: { time in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    buttonActive = true
                }
            })
        }
    }
    
    func limitText(_ upper: Int) {
        if viewModel.otpText.count > upper {
            viewModel.otpText = String(viewModel.otpText.prefix(upper))
        }
    }
}

//#Preview {
//    EnterCodeView()
//}
