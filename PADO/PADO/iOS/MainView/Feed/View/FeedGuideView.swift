//
//  FeedGuideView.swift
//  PADO
//
//  Created by 강치우 on 2/14/24.
//

import Kingfisher
import SwiftUI

struct FeedGuideView: View {
    @ObservedObject var feedVM: FeedViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 8) {
                Text("인기 팔로워")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                VStack {
                    Text("계정을 팔로우하여 최신 게시물을")
                    
                    Text("여기서 확인하세요.")
                }
                .foregroundColor(.gray)
                .font(.footnote)
                .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding([.leading, .top], 15)
            .padding(.bottom)
            
            GeometryReader(content: { geometry in
                let size = geometry.size
                let frameWidth = max(size.width - 80, 0)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        ForEach(feedVM.popularUsers) { user in
                            FeedGuideCell(user: user)
                                .frame(width: frameWidth, height: size.height - 0)
                                .scrollTransition(.interactive, axis: .horizontal) {
                                    view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .top)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            })
            .frame(height: 400)
            .padding(.top, 10)
            Spacer()
        }
    }
    
}
