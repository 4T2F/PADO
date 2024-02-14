//
//  FeedGuideView.swift
//  PADO
//
//  Created by 강치우 on 2/14/24.
//

import SwiftUI

struct FeedGuideView: View {
    var body: some View {
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
            
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(tripCards) { card in
                        GeometryReader(content: { proxy in
                            let cardSize = proxy.size
                            let minX = proxy.frame(in: .scrollView).minX - 30.0
                            
                            Image(card.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .offset(x: -minX)
                                .frame(width: cardSize.width, height: cardSize.height)
                                .overlay {
                                    overlayView(card)
                                }
                                .clipShape(.rect(cornerRadius: 15))
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                        })
                        .frame(width: size.width - 80, height: size.height - 0)
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

    }
    
    @ViewBuilder
    func overlayView(_ card: SuggestionModel) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.2),
                .black.opacity(0.3),
                .black.opacity(0.4),
                .black.opacity(0.5),
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
                
//                FollowButtonView(cellUserId: <#T##String#>, buttonActive: <#T##Binding<Bool>#>, activeText: <#T##String#>, unActiveText: <#T##String#>, widthValue: <#T##CGFloat#>, heightValue: <#T##CGFloat#>)
            })
            .padding(20)
        })
    }
}
