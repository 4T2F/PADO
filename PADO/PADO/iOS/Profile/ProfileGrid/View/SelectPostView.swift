//
//  GridDetailView.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Kingfisher
import SwiftUI

enum PostViewType {
    case receive
    case send
    case highlight
}

struct SelectPostView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var feedVM: FeedViewModel

    let updateHeartData = UpdateHeartData()
    var viewType: PostViewType
    
    @Binding var isShowingDetail: Bool
    @GestureState private var dragState = CGSize.zero
    @State private var isDetailViewReady = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { value in
                        LazyVStack(spacing: 0) {
                            switch viewType {
                            case .receive:
                                ForEach(profileVM.padoPosts.indices, id: \.self) { index in
                                    SelectPostCell(profileVM: profileVM,
                                                   updateHeartData: updateHeartData,
                                                   post: $profileVM.padoPosts[index],
                                                   cellType: PostViewType.receive)
                                    .id(profileVM.padoPosts[index].id)
                                }
                                
                            case .send:
                                ForEach(profileVM.sendPadoPosts.indices, id: \.self) { index in
                                    SelectPostCell(profileVM: profileVM,
                                                   updateHeartData: updateHeartData,
                                                   post: $profileVM.sendPadoPosts[index],
                                                   cellType: PostViewType.send)
                                    .id(profileVM.sendPadoPosts[index].id)
                                }
                            case .highlight:
                                ForEach(profileVM.highlights.indices, id: \.self) { index in
                                    SelectPostCell(profileVM: profileVM,
                                                   updateHeartData: updateHeartData,
                                                   post: $profileVM.highlights[index],
                                                   cellType: PostViewType.highlight)
                                    .id(profileVM.highlights[index].id)
                                }
                            }
                            
                        }
                        .scrollTargetLayout()
                        .onAppear {
                            Task {
                                try? await Task.sleep(nanoseconds: 1 * 100_000_000)
                                value.scrollTo(profileVM.selectedPostID, anchor: .top)
                            }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .top) {
                        Button {
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.isShowingDetail = false
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Text(titleForType(viewType))
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .padding(.trailing, 15)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
        }
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.height > 100 || abs(value.translation.width) > 100 {
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                            isShowingDetail = false // 드래그가 일정 임계값을 넘어서면 뷰 닫기
                        }
                    }
                }
        )
    }
    

    // 각 뷰 타입에 맞는 제목 반환
    private func titleForType(_ type: PostViewType) -> String {
        switch type {
        case .receive:
            return "받은 파도"
        case .send:
            return "보낸 파도"
        case .highlight:
            return "하이라이트"
        }
    }
}
