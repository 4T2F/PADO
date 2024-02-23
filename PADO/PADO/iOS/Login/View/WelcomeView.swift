//
//  WelcomeView.swift
//  PADO
//
//  Created by 최동호 on 2/23/24.
//

import Lottie
import SwiftUI

enum SignType {
    case signIn
    case signUp
}

struct WelcomeView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            VStack {
                switch viewModel.signType {
                case .signIn:
                    LottieView(animation: .named("pokjuk2"))
                        .resizable()
                        .playing()
                        .offset(y: -20)
                    Text("\(userNameID)님 돌아오신걸 환영합니다")
                case .signUp:
                    LottieView(animation: .named("pokjuk2"))
                        .resizable()
                        .playing()
                        .offset(y: -20)
                    Text("\(userNameID)님 환영합니다")
                    
                    Text("이제부터 파도를 이용해보세요")
                }
            }
        }
    }
}
