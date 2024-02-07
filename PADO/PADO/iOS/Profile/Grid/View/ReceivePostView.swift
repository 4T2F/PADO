//
//  GridDetailView.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct ReceivePostView: View {
    @ObservedObject var feedVM: FeedViewModel
    @StateObject var profileVM: ProfileViewModel
    @StateObject var surfingVM: SurfingViewModel
    
    let updateHeartData = UpdateHeartData()
    
    @Binding var isShowingReceiveDetail: Bool
    @GestureState private var dragState = CGSize.zero
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                ScrollViewReader { value in
                    LazyVStack(spacing: 0) {
                        ForEach (profileVM.padoPosts, id: \.self) { post in
                            ReceivePostCell(feedVM: feedVM, profileVM: profileVM, surfingVM: surfingVM ,updateHeartData: updateHeartData, post: post)
                                .id(post)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea(.all, edges: .top)
            .padding(.bottom, 0.2)
            
            VStack {
                HStack(alignment: .top) {
                    Button {
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                            self.isShowingReceiveDetail = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22))
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Text("받은 파도")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .padding(.trailing, 15)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.height > 100 || abs(value.translation.width) > 100 {
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                            isShowingReceiveDetail = false // 드래그가 일정 임계값을 넘어서면 뷰 닫기
                        }
                    }
                }
        )
    }
}
