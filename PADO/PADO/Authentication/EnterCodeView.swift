//
//  EnterCodeView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI
import Combine

struct EnterCodeView: View {
    
    @State var otpCode = ""
    @State var buttonActive = false
    
    @State var timeRemaining = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("BeReal.")
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
                            Text("Enter the code we sent to +39 389 939 02 12")
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                            
                            Text("......")
                                .foregroundStyle(otpCode.isEmpty ? .gray : .black)
                                .opacity(0.8)
                                .font(.system(size: 70))
                                .padding(.top, -40)
                                .overlay {
                                    TextField("", text: $otpCode)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 24))
                                        .fontWeight(.heavy)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(otpCode), perform: { _ in
                                            limitText(6)
                                        })
                                        .onReceive(Just(otpCode), perform: { newValue in
                                            let filtered = newValue.filter({
                                                Set("0123456789").contains($0)})
                                            
                                            if filtered != newValue {
                                                otpCode = filtered
                                            }
                                        })
                                }
                        }
                        .padding(.top, 50)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Text("Change the phone number")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        
                        Button {
                            
                        } label: {
                            WhiteButtonView(buttonActive: $buttonActive, text: otpCode.count == 6 ? "Continue" : "Resend in \(timeRemaining)s" )
                        }
                        .disabled(buttonActive ? false : true)
                        .onChange(of: otpCode) { oldValue, newValue in
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
        if otpCode.count > upper {
            otpCode = String(otpCode.prefix(upper))
        }
    }
}

#Preview {
    EnterCodeView()
}
