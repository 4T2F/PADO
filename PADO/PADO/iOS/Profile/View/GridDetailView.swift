//
//  GridDetailView.swift
//  PADO
//
//  Created by 강치우 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct GridDetailView: View {
    @ObservedObject var feedVM: FeedViewModel
    
    @Binding var showDetail: Bool
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach (0..<10) { post in
                        GridCell(feedVM: feedVM, showDetail: $showDetail)
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
                            self.showDetail = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22))
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Text("hanabi")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .padding(.trailing, 15)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}
