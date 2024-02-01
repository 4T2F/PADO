//
//  FollowMainView.swift
//  PADO
//
//  Created by 강치우 on 2/1/24.
//

import SwiftUI

struct FollowMainView: View {
    @State var currentType: String = "팔로워"
    @Namespace var animation
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var followVM: FollowViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Text("\(userNameID)")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("dismissArrow")
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            PinnedHeaderView()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                            PostList()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let types: [String] = ["팔로워", "팔로잉"]
        
        HStack(spacing: 25) {
            ForEach(types, id: \.self) { type in
                VStack(spacing: 12) {
                    Text(type)
                        .foregroundStyle(currentType == type ? .white : .gray)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    ZStack {
                        if currentType == type {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.white)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        } else {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.clear)
                        }
                    }
                    .frame(height: 1)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        currentType = type
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 25)
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func PostList() -> some View {
        switch currentType {
        case "팔로워":
            FollowerView(followVM: followVM)
        case "팔로잉":
            FollowingView(followVM: followVM)
        default:
            EmptyView()
        }
    }
}
