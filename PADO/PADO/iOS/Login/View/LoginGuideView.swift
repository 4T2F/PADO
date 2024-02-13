//
//  LoginGuideView.swift
//  PADO
//
//  Created by 최동호 on 2/13/24.
//

import SwiftUI

struct LoginGuideView: View {
    
    var body: some View {
        ZStack {
            Color.modal.ignoresSafeArea()
            VStack {
                Text("로그인이 필요한 서비스입니다")
                    .foregroundStyle(.white)
                    .background(.clear)
            }
        }
        .padding()
    }
}
