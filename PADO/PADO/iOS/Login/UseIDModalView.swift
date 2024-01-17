//
//  UseIDModalView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct UseIDModalView: View {
    
    @State private var buttonActive: Bool = true
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            Color.modal.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 15, content: {
//                // Back Button
//                Button(action: {
//                    dismiss()
//                }, label: {
//                    Image(systemName: "arrow.left")
//                        .font(.title2)
//                        .foregroundStyle(.gray)
//                })
//                .padding(.top, 10)
                Text("이미 가입된 사용자 입니다")
                    .font(.system(size: 24))
                    .fontWeight(.heavy)
                    .padding(.top, 5)
                
                VStack(spacing: 20) {
                    Button {
                        Task {
                            await viewModel.fetchUser()
                        }
                    } label: {
                        ModalWhiteButton(buttonActive: $buttonActive, text: "로그인 하기")
                    }
                    
                    Button {
                        // StartView 이동
                    } label: {
                        ModalBlackButton(buttonActive: $buttonActive, text: "시작 화면으로 이동")
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, -25)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
        .interactiveDismissDisabled()
        }
    }
}

#Preview {
    UseIDModalView()
}
