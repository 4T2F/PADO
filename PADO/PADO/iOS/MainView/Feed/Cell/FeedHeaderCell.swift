//
//  FeedHeaderCell.swift
//  PADO
//
//  Created by 황성진 on 2/6/24.
//

import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import Lottie
import SwiftUI

enum FeedFilter: Int, CaseIterable, Identifiable {
    case following
    case today
    
    var title: String {
        switch self {
        case .following: return "팔로잉"
        case .today: return "인기"
        }
    }
    var id: Int { return self.rawValue }
}

struct FeedHeaderCell: View {
    // MARK: - PROPERTY
    @State private var selectedFilter: FeedFilter = .following
    @Namespace var animation
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(FeedFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 160
    }
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack(spacing: 22) {
                    ForEach(FeedFilter.allCases) { filter in
                        VStack(spacing: 4) {
                            Text(filter.title)
                                .font(.system(size: 18))
                                .fontWeight(selectedFilter == filter ? .semibold : .medium)
                                .foregroundStyle(selectedFilter == filter ? .white : .gray)
                            
                            if selectedFilter == filter {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.white)
                                    .frame(width: filterBarWidth, height: 1.5)
                                    .matchedGeometryEffect(id: "item", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.clear)
                                    .frame(width: filterBarWidth, height: 1.5)
                            }
                            
                        } //: VSTACK
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedFilter = filter
                                viewModel.selectFilter = filter
                            }
                        }
                    } //: LOOP
                } //: HSTACK
            } //: VSTACK
            .padding(.leading, 30)
            
            Spacer()
            
            NavigationLink(destination: NotificationView()) {
                Image("Bell_pin_light")
            }
        }
        .padding(.horizontal)
    }
}

