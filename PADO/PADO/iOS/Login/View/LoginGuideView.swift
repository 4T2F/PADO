//
//  LoginGuideView.swift
//  PADO
//
//  Created by 최동호 on 2/13/24.
//

import SwiftUI

struct LoginGuideView: View {
    @State private var showing = false
    var body: some View {
        ZStack {
            Color.modal.ignoresSafeArea()
            VStack {
                Button {
                    showing = true
                } label: {
                    Text("로그인이 필요한 서비스입니다")
                        .foregroundStyle(.white)
                        .background(.clear)
                }
                .sheet(isPresented: $showing, content: {
                    StartView()
                        .presentationDragIndicator(.visible)
                })
            }
        }
    }
}
