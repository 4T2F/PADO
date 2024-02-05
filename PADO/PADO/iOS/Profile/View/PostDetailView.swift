//
//  ProfileGridView.swift
//  PADO
//
//  Created by 강치우 on 2/5/24.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    var post: Post
    var animation: Namespace.ID
    @Binding var showDetail: Bool // 상세 화면 표시 상태를 관리하는 바인딩 변수
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = URL(string: post.imageUrl) {
                KFImage(image)
                    .resizable()
                    .scaledToFit()
                    // MatchedGeometryEffect 적용
                    .matchedGeometryEffect(id: post.id, in: animation)
            }
            
            Button(action: {
                withAnimation(.easeInOut) {
                    showDetail = false
                }
            }) {
                Image(systemName: "xmark")
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}
