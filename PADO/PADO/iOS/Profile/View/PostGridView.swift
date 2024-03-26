//
//  PostGridView.swift
//  PADO
//
//  Created by 강치우 on 3/11/24.
//

import Kingfisher

import SwiftUI

struct PostGridView: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    @Binding var isShowingDetail: Bool
    
    var text: String
    var posts: [Post]
    var fetchedData: Bool
    var postViewType: PostViewType
    
    let columns = [GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 25) {
            if posts.isEmpty {
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
                                                   userID: userNameID,
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
                                switch postViewType {
                                case .receive:
                                    await profileVM.fetchMorePadoPosts(id: userNameID)
                                case .send:
                                    await profileVM.fetchMoreSendPadoPosts(id: userNameID)
                                case .highlight:
                                    await profileVM.fetchMoreHighlihts(id: userNameID)
                                }
                            }
                    }
                }
            }
        }
        .padding(.bottom, 100)
        .offset(y: -4)
    }
}
