//
//  Spotify.swift
//  Components
//
//  Created by 강치우 on 1/30/24.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @State var currentType: String = "파도"
    @Namespace var animation
    
    @State var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    @State var buttonOnOff: Bool = false
  
    @EnvironmentObject var viewModel: AuthenticationViewModel

    @StateObject var followVM: FollowViewModel
    
    let columns = [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                headerView()
                
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        postList()
                    } header: {
                        pinnedHeaderView()
                            .background(Color.black)
                            .offset(y: headerOffsets.1 > 0 ? 0 : -headerOffsets.1 / 8)
                            .modifier(OffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $headerOffsets.1))
                    }
                }
            }
        }
        .overlay {
            Rectangle()
                .fill(.black)
                .frame(height: 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(headerOffsets.0 < 5 ? 1 : 0)
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
    }
    
    @ViewBuilder
    func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            Image("pp2")
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Circle()
                                .frame(height: 70)
                                .overlay {
                                    CircularImageView(size: .xxLarge)
                                }
                            
                            HStack(alignment: .bottom, spacing: 10) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(viewModel.currentUser?.username ?? "")")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Text("@\(userNameID)")
                                        .font(.title.bold())
                                }
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.blue)
                                    .background {
                                        Circle()
                                            .fill(.white)
                                            .padding(3)
                                    }
                                    .offset(y: -5)
                                
                                Spacer()
                                
                                NavigationLink(destination: SettingProfileView()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius:4)
                                            .stroke(Color.white, lineWidth: 1)
                                            .frame(width: 80, height: 28)
                                        Text("프로필 편집")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundStyle(.white)
                                    }
                                }
                                
//                                Button {
//                                    buttonOnOff.toggle()
//                                } label: {
//                                    if buttonOnOff {
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius:6)
//                                                .stroke(Color.white, lineWidth: 1)
//                                                .frame(width: 70, height: 28)
//                                            Text("팔로잉")
//                                                .font(.system(size: 14))
//                                                .fontWeight(.medium)
//                                                .foregroundStyle(.white)
//                                        }
//                                    } else {
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius:6)
//                                                .stroke(Color.blue, lineWidth: 1)
//                                                .frame(width: 70, height: 28)
//                                            Text("팔로우")
//                                                .font(.system(size: 14))
//                                                .fontWeight(.medium)
//                                                .foregroundStyle(.white)
//                                        }
//                                    }
//                                }
                            }
                                                       
                            HStack {
                                Label {
                                    Text("파도")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.7))
                                } icon: {
                                    Text("0")
                                        .fontWeight(.semibold)
                                }
                                .font(.caption)
                                
                                NavigationLink(destination: FollowView(followVM: followVM)) {
                                    Label {
                                        Text("팔로워")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.7))
                                    } icon: {
                                        Text("\(followVM.followerIDs.count + followVM.surferIDs.count)")
                                            .fontWeight(.semibold)
                                    }
                                    .font(.caption)
                                }
                                
                                NavigationLink(destination: FollowView(followVM: followVM)) {
                                    Label {
                                        Text("팔로잉")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.7))
                                    } icon: {
                                        Text("\(followVM.followingIDs.count)")
                                            .fontWeight(.semibold)
                                    }
                                    .font(.caption)
                                }
                            }
                            .padding(.leading, 2)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .cornerRadius(0)
                .offset(y: -minY)
            
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 22))
                    }
                }
                .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }
        .frame(height: 300)
    }
    
    @ViewBuilder
    func pinnedHeaderView() -> some View {
        let types: [String] = ["파도", "보낸 파도", "하이라이트"]
        HStack(spacing: 25) {
            ForEach(types, id: \.self) { type in
                VStack(spacing: 12) {
                    Text(type)
                        .fontWeight(.semibold)
                        .foregroundStyle(currentType == type ? .white : .gray)
                    
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
                    .padding(.horizontal, 8)
                    .frame(height: 4)
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
    func postList() -> some View {
        switch currentType {
        case "파도":
            postView()
        case "보낸 파도":
            writtenPostsView()
        case "하이라이트":
            highlightsView()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func postView() -> some View {
        VStack(spacing: 25) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(1...10, id: \.self) { _ in
                    ZStack(alignment: .bottomLeading) {
                        Image("B12")
                            .resizable()
                        
                        Text("친구가 내 파도에 쓴 글")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .padding([.leading, .bottom], 5)
                    }
                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                }
            }
        }
        .padding(.bottom, 150)
        .padding(.top, 5)
    }
    
    @ViewBuilder
    func writtenPostsView() -> some View {
        VStack(spacing: 25) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(1...1, id: \.self) { _ in
                    ZStack(alignment: .bottomLeading) {
                        Image("B11")
                            .resizable()
                        
                        Text("내가 친구 파도에 쓴 글")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .padding([.leading, .bottom], 5)
                    }
                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                }
            }
        }
        .padding(.bottom, 150)
    }
    
    @ViewBuilder
    func highlightsView() -> some View {
        VStack(spacing: 25) {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(1...5, id: \.self) { _ in
                    ZStack(alignment: .bottomLeading) {
                        Image("B14")
                            .resizable()
                        
                        Text("내가 좋아요 한 파도")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .padding([.leading, .bottom], 5)
                    }
                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                }
            }
        }
        .padding(.bottom, 150)
    }
}

