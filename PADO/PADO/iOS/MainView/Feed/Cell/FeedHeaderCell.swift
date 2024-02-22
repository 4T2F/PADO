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
        case .following: return "Following"
        case .today: return "Today"
        }
    }
    var id: Int { return self.rawValue }
}

struct FeedHeaderCell: View {
    // MARK: - PROPERTY
    @Namespace var animation
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var notiVM: NotificationViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var feedVM: FeedViewModel
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(FeedFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 140
    }
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack(spacing: 16) {
                    ForEach(FeedFilter.allCases) { filter in
                        VStack(spacing: 4) {
                            Text(filter.title)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundStyle(viewModel.selectedFilter == filter ? .white : .white.opacity(0.6))
                            
                            if viewModel.selectedFilter == filter {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.white)
                                    .frame(width: filterBarWidth, height: 2.5)
                                    .matchedGeometryEffect(id: "item", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.clear)
                                    .frame(width: filterBarWidth, height: 2.5)
                            }
                        } //: VSTACK
                        .onTapGesture {
                            withAnimation(.spring()) {
                                viewModel.selectedFilter = filter
                            }
                        }
                    } //: LOOP
                } //: HSTACK
            } //: VSTACK
            .padding(.leading, 30)
            
            Spacer()
            
            if !userNameID.isEmpty {
                NavigationLink(destination: NotificationView(profileVM: profileVM,
                                                             feedVM: feedVM,
                                                             notiVM: notiVM)) {
                    Image(notiVM.hasNewNotifications ? "Bell_pin_light" : "Bell_light") // 조건부 아이콘 변경
                }
            } else {
               Image("Bell_light")
                    .foregroundStyle(.clear)
                    .opacity(0)
            }
        }
        .padding(.horizontal)
    }
}

struct FeedRefreshHeaderCell: View {
    // MARK: - BODY
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack(spacing: 22) {
                    Text("아래로 드래그해서 새로고침")
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                } //: HSTACK
            } //: VSTACK
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
