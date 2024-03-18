//
//  FeedCell.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import Firebase
import FirebaseFirestoreSwift

import SwiftUI

struct FeedCell: View {
    @StateObject var feedCellVM = FeedCellViewModel()
    
    @Binding var post: Post
    
    var body: some View {
        ZStack {
            if feedCellVM.currentPadoRideIndex == nil || feedCellVM.padoRidePosts.isEmpty {
                // MARK: 사진
                ImageLoadingCell(isLoading: $feedCellVM.isLoading,
                                 isHeaderVisible: $feedCellVM.isHeaderVisible,
                                 imageUrl: post.imageUrl)
            } else if let currentIndex = feedCellVM.currentPadoRideIndex,
                      feedCellVM.padoRidePosts.indices.contains(currentIndex) {
                // MARK: 파도타기
                PadoRideImageCell(isLoading: $feedCellVM.isLoading,
                                  isHeaderVisible: $feedCellVM.isHeaderVisible,
                                  padoRide: feedCellVM.padoRidePosts[currentIndex])
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    // MARK: 아이디 및 타이틀
                    VStack(alignment: .leading, spacing: 12) {
                        PostContentCell(feedCellVM: feedCellVM,
                                        post: post)
                        
                        if let user = feedCellVM.postUser {
                            UserProfileSection(buttonOnOff: $feedCellVM.postOwnerButtonOnOff,
                                               username: user.username,
                                               userId: post.ownerUid,
                                               user: user)
                        }
                    }
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // MARK: 액션 버튼
                    ActionButtonsSection(feedCellVM: feedCellVM,
                                         post: $post)
                }
            }
            .padding()
        }
        .overlay(alignment: .topLeading, content: {
            ZStack {
                ForEach(feedCellVM.likedCounter) { like in
                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: like.size))
                        .foregroundStyle(.red.gradient)
                    
                        .animation(.smooth, body: { view in
                            view
                                .scaleEffect(like.isAnimated ? 1.0 : 2.5)
                                .rotationEffect(.init(degrees: like.isAnimated ? 0 : .random(in: -90...90)))
                                .opacity(like.isAnimated ? 0 : 10.0)
                        })
                        .offset(x: like.tappedRect.x - 50, y: like.tappedRect.y - 50)
                        .offset(y: like.isAnimated ? -(like.tappedRect.y) : 0)
                }
            }
        })
        .onTapGesture(count: 2) { position in
            // MARK: 더블 탭 시 실행할 로직
            feedCellVM.doubleTapCell(size: 75,
                                     position: position,
                                     post: post)
        }
        .onAppear {
            Task {
                await feedCellVM.fetchPostData(post: post)
            }
        }
            
    }
}
