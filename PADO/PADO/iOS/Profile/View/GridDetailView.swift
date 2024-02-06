//
//  GridDetailView.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct GridDetailView: View {
    @StateObject var profileVM: ProfileViewModel
    var animation: Namespace.ID
    @Binding var showDetail: Bool
    @Binding var selectedItemIndex: Int?  // 추가
    
    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { value in  // ScrollViewReader 추가
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(profileVM.padoPosts.indices, id: \.self) { index in  // index 사용
                            let post = profileVM.padoPosts[index]
                            ZStack(alignment: .bottomLeading) {
                                if let image = URL(string: post.imageUrl) {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: proxy.size.width, height: proxy.size.height)
                                }
                                Text(post.title)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                                    .padding([.leading, .bottom], 5)
                            }
                            .id(index)
                        }
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                .scrollTargetLayout()
                .scrollTargetBehavior(.paging)
                .onAppear {
                    if let selectedItemIndex = selectedItemIndex {
                        value.scrollTo(selectedItemIndex, anchor: .center)  // 선택된 인덱스로 스크롤
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                self.showDetail = false
            }
        }
    }
}
