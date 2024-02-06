//
//  FeedHeaderCell.swift
//  PADO
//
//  Created by 황성진 on 2/6/24.
//

import SwiftUI

enum FeedFilter: Int, CaseIterable, Identifiable {
    case following
    case today
    
    var title: String {
        switch self {
        case .following: return "팔로잉"
        case .today: return "오늘 파도"
        }
    }
    var id: Int { return self.rawValue }
}

struct FeedHeaderCell: View {
    // MARK: - PROPERTY
    @State private var selectedFilter: FeedFilter = .following
    @Namespace var animation
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(FeedFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 100
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                ForEach(FeedFilter.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.system(size: 16))
                            .fontWeight(selectedFilter == filter ? .bold : .semibold)
                            .foregroundStyle(selectedFilter == filter ? .white : .gray)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .foregroundStyle(.white)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
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
                } //: LOOP
            } //: HSTACK
            .padding(.vertical, 8)
        } //: VSTACK
    }
}

