//
//  PostContentView.swift
//  PADO
//
//  Created by 강치우 on 3/17/24.
//

import SwiftUI

struct PostContentCell: View {
    @ObservedObject var feedCellVM: FeedCellViewModel
    
    var post: Post
    
    var body: some View {
        if feedCellVM.isHeaderVisible {
            if !post.title.isEmpty {
                Button {
                    feedCellVM.isShowingMoreText.toggle()
                } label: {
                    if feedCellVM.isShowingMoreText {
                        Text("\(post.title)")
                            .font(.system(.subheadline))
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.modal.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .padding(.bottom, 4)
                            .padding(.trailing, 24)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("\(post.title)")
                            .font(.system(.subheadline))
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .padding(8)
                            .background(.modal.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .padding(.bottom, 4)
                            .padding(.trailing, 24)
                    }
                }
                .lineSpacing(1)
                .fontWeight(.bold)
                .padding(.trailing, 20)
            }
            // MARK: - 서퍼
            if let surferUser = feedCellVM.surferUser {
                NavigationLink {
                    OtherUserProfileView(buttonOnOff: $feedCellVM.postSurferButtonOnOff,
                                         user: surferUser)
                    
                } label: {
                    Text("surf. @\(post.surferUid)")
                }
                .font(.system(.callout))
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(8)
                .background(.modal.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .padding(.bottom, 4)
                .padding(.trailing, 24)
                
            }
        } else {
            if let currentIndex = feedCellVM.currentPadoRideIndex {
                Text("\(feedCellVM.padoRidePosts[currentIndex].id ?? "")님의 파도타기")
                    .font(.system(.callout))
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.modal.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .padding(.bottom, 4)
                    .padding(.trailing, 24)
            }
        }
    }
}
