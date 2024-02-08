//
//  ProfileGridView.swift
//  PADO
//
//  Created by 강치우 on 2/5/24.
//

import Kingfisher
import SwiftUI

struct PostDetailView: View {
    var post: Post
    var animation: Namespace.ID
    @Binding var showDetail: Bool // 상세 화면 표시 상태를 관리하는 바인딩 변수
    
    var body: some View {
        ZStack {
            if let image = URL(string: post.imageUrl) {
                KFImage(image)
                    .resizable()
                    .scaledToFill()
            }
       
            Text(post.title)
                .foregroundStyle(.white)
                .font(.system(size: 14))
                .padding()
                .matchedGeometryEffect(id: post.title, in: animation)
  
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showDetail = false
            }
        }
    }
}
