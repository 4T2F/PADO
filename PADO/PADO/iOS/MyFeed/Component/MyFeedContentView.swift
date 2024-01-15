//
//  MyFeedFilter.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import SwiftUI

enum MyFeedFilter: Int, CaseIterable, Identifiable {
    case myfeed
    case mypost
    
    var title: String {
        switch self {
        case .myfeed: return "square.grid.3x3.square"
        case .mypost: return "heart.text.square"
        }
    }
    
    var id: Int { return self.rawValue }
}

struct MyFeedContentView: View {
    // MARK: - PROPERTY
    @State private var selectedFilter: MyFeedFilter = .myfeed
    @Namespace var animation
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(MyFeedFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 150
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                ForEach(MyFeedFilter.allCases) { filter in
                    VStack {
                        Image(systemName: filter.title)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 22)
                            .fontWeight(selectedFilter == filter ? .bold : .regular)
                            .foregroundStyle(selectedFilter == filter ? .white : .grayButton)
                            .padding(.horizontal, 50)
                            .padding(.vertical)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .foregroundStyle(.white)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "itme", in: animation)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: filterBarWidth, height: 1)
                        }
                    } //: VSTACK
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                    
                } // LOOP
            } //: HSTACK
            
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(1...10, id: \.self) { _ in
                        ZStack(alignment: .leading) {
                            Image("pp")
                                .resizable()
                                .frame(width: 190, height: 300)
                            
                            Text("시리우스 셀카 사진")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .bold))
                                .offset(y: 100)
                            
                            Text("Dog Star")
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .semibold))
                                .offset(y: 130)
                        } //: ZSTACK
                    } //: LOOP
                } // GRID
            } //: SCROLL
        } //: VSTACK
    }
}

#Preview {
    MyFeedContentView()
}
