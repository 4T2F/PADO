//
//  FeedCell.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

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
            HeartEffectView(hearts: feedCellVM.hearts)
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
