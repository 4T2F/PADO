//
//  OtherUserPostGridView.swift
//  PADO
//
//  Created by 강치우 on 3/14/24.
//

import Kingfisher
import Lottie

import SwiftUI

struct OtherUserPostGridView: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    @Binding var isShowingDetail: Bool
    
    var posts: [Post]
    var fetchedData: Bool
    var isFetchingData: Bool
    var text: String
    var postViewType: PostViewType
    var userID: String
    
    let columns = [GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 25) {
            if isFetchingData {
                LottieView(animation: .named("Loading"))
                    .looping()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 60)
            } else if posts.isEmpty {
                NoItemView(itemName: text)
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(posts, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                Button {
                                    isShowingDetail.toggle()
                                    profileVM.isFirstPostOpen.toggle()
                                    profileVM.selectedPostID = post.id ?? ""
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingDetail) {
                                    SelectPostView(profileVM: profileVM,
                                                   isShowingDetail: $isShowingDetail,
                                                   userID: userID,
                                                   viewType: postViewType)
                                    .presentationDragIndicator(.visible)
                                    
                                }
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                    if fetchedData {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .task {
                                try? await Task.sleep(nanoseconds: 1 * 1000_000_000)
                                switch postViewType {
                                case .receive:
                                    await profileVM.fetchMorePadoPosts(id: userID)
                                case .send:
                                    await profileVM.fetchMoreSendPadoPosts(id: userID)
                                case .highlight:
                                    await profileVM.fetchMoreHighlihts(id: userID)
                                }
                            }
                    }
                }
            }
        }
        .offset(y: -4)
    }
}
