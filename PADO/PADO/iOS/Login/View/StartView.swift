//
//  StartView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct StartView: View {
    @StateObject var loginVM = LoginViewModel()

    @Binding var isShowStartView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    ForEach(1...3, id: \.self) { index in
                        Image("Pic\(index)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .opacity(loginVM.titleIndex == (index - 1) ? 1 : 0)
                    }
                    LinearGradient(colors: [.clear, .black.opacity(0.5), .black], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    VStack {
                        HStack(spacing: 0) {
                            ForEach(loginVM.titleText) { text in
                                Text(text.text)
                                    .offset(y: text.offset)
                            }
                            .font(.largeTitle.bold())
                        }
                        .offset(y: loginVM.endAnimation ? -50 : 0)
                        .opacity(loginVM.endAnimation ? 0 : 1)

                        Text(loginVM.subTitles[loginVM.titleIndex])
                            .opacity(0.7)
                            .offset(y: !loginVM.subTitleAnimation ? 70 : 0)
                            .offset(y: loginVM.endAnimation ? -50 : 0)
                            .opacity(loginVM.endAnimation ? 0 : 1)
                            .padding(.top, 5)
                    }
                    .padding(.bottom, 80)
                    
                    HStack(spacing: 20) {
                        NavigationLink {
                            SignUpView(loginVM: loginVM,
                                       loginSignUpType: LoginSignUpType.signUp,
                                       isShowStartView: $isShowStartView)
                        } label: {
                            SignUpButton(text: "회원가입")
                        }
                        
                        NavigationLink {
                            SignUpView(loginVM: loginVM,
                                       loginSignUpType: LoginSignUpType.login,
                                       isShowStartView: $isShowStartView)
                        } label: {
                            EnjoyButton(text: "로그인")
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .onAppear {
                if loginVM.titleText.isEmpty {
                    loginVM.startAnimation()
                }
            }
            .onChange(of: loginVM.titleIndex) { _, _ in
                loginVM.startAnimation()
            }
        }
    }
}
