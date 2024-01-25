//
//  LoginAlert.swift
//  PADO
//
//  Created by 최동호 on 1/15/24.
//

import SwiftUI

struct LoginAlert: View {
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.mainBackground).opacity(0.2)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        // dismiss
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 15)
                }
                
                Text("로그인하고 이용하기")
                    .foregroundStyle(.white)
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .padding(.bottom, 8)
                
                Text("이 기능은, 로그인을 해야 이용할 수 있어요!")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .padding(.bottom, 5)

                
                Button {
                    // 로그인화면으로 이동
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.horizontal, 60)
                            .frame(height: 35)
                            .foregroundStyle(.blueButton)
                        Text("로그인")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            
                    }
                }
                .padding(.bottom, 10)
                
                
            }
            
        }
        .frame(height: 160)
        .padding(.horizontal, 50)
    }
}


#Preview {
    LoginAlert()
}
