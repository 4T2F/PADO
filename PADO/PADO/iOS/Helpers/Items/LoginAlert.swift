//
//  LoginAlert.swift
//  PADO
//
//  Created by 최동호 on 1/15/24.
//

import SwiftUI

struct LoginAlert: View {
    @State private var isShowingLoginPage: Bool = false
    
    var body: some View {
        ZStack {
            Color.main.ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white)
                .foregroundStyle(.black).opacity(0.2)
                .frame(height: 160)
                .padding(.horizontal, 50)
            VStack {
                HStack {
                    Spacer()
                }
                Text("로그인이 필요한 서비스 입니다")
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)
                
                Text("이 기능은 로그인 후 이용할 수 있습니다.")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .padding(.bottom, 10)

                Button {
                    isShowingLoginPage = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.horizontal, 60)
                            .frame(height: 35)
                            .foregroundStyle(.blueButton)
                        Text("로그인")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 50)
                }
                .sheet(isPresented: $isShowingLoginPage, content: {
                    StartView()
                        .presentationDragIndicator(.visible)
                })
                .padding(.bottom, 10)
            }
        }
    }
}

