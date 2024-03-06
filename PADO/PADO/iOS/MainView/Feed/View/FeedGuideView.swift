//
//  FeedGuideView.swift
//  PADO
//
//  Created by 강치우 on 2/14/24.
//

import Kingfisher
import SwiftUI

struct FeedGuideView: View {
    let title: String
    let content: String
    
    let popularUsers: [User]

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    Text("\(title)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    VStack {
                        Text("\(content)")
                            .multilineTextAlignment(.center)
  
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
                            ForEach(popularUsers) { user in
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
    
}
