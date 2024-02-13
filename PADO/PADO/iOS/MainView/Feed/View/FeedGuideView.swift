//
//  FeedGuideView.swift
//  PADO
//
//  Created by 최동호 on 2/13/24.
//

import SwiftUI

struct FeedGuideView: View {
    var body: some View {
        ZStack {
            Color.modal.ignoresSafeArea()
            VStack {
                Text("계정을 팔로우하여 최신 게시글을 여기서 확인하세요.")
                    .foregroundStyle(.white)
                    .background(.clear)
            }
        }
        .padding()
    }
}
