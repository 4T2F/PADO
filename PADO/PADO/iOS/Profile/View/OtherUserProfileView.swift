//
//  OtherUserProfileView.swift
//  PADO
//
//  Created by 최동호 on 2/2/24.
//


import Kingfisher
import SwiftUI

struct OtherUserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var followVM = FollowViewModel()
    
    @Namespace var animation
    
    @Environment(\.dismiss) var dismiss
  
    @State private var buttonOnOff = false
    @State private var buttonActive: Bool = false
    
    let updateFollowData = UpdateFollowData()
    
    let user: User
    
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
                            .modifier(OffsetModifier(offset: $profileVM.headerOffsets.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $profileVM.headerOffsets.1))
                    }
                }
            }
        }
        .overlay {
            Rectangle()
                .fill(.black)
                .frame(height: 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(profileVM.headerOffsets.0 < 5 ? 1 : 0)
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                followVM.profileFollowId = user.nameID
                followVM.initializeFollowFetch()
                await profileVM.fetchPostID(id: user.nameID)
                self.buttonOnOff = await updateFollowData.checkFollowStatus(id: user.nameID)
            }
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            Image("pp")
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.clear,
                                                .black.opacity(0.1),
                                                .black.opacity(0.3),
                                                .black.opacity(0.5),
                                                .black.opacity(0.8),
                                                .black.opacity(1)], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                         
                            CircularImageView(size: .xLarge, user: user)
                            
                            HStack(alignment: .bottom, spacing: 10) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(user.username)")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Text("@\(user.nameID)")
                                        .font(.title.bold())
                                }
                                
                                if !user.instaAddress.isEmpty || !user.tiktokAddress.isEmpty {
                                    Button {
                                        buttonActive.toggle()
                                    } label: {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundStyle(.blue)
                                            .background {
                                                Circle()
                                                    .fill(.white)
                                                    .padding(3)
                                            }
                                            .offset(y: -5)
                                    }
                                    .sheet(isPresented: $buttonActive, content: {
                                        ProfileBadgeModalView(user: user)
                                            .presentationDetents([
                                                .fraction(!user.instaAddress.isEmpty && !user.tiktokAddress.isEmpty ? 0.3 : 0.2)
                                            ])
                                            .presentationCornerRadius(20)
                                            .presentationDragIndicator(.visible)
                                        
                                    })
                                }
                                
                                Spacer()
                                
                                if user.nameID == userNameID {
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
                                } else {
                                    
                                    if buttonOnOff {
                                        Button {
                                            Task {
                                                await updateFollowData.directUnfollowUser(id: user.nameID)
                                                buttonOnOff.toggle()
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius:6)
                                                    .stroke(Color.white, lineWidth: 1)
                                                    .frame(width: 70, height: 28)
                                                Text("팔로잉")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    } else {
                                        Button {
                                            Task {
                                                await updateFollowData.followUser(id: user.nameID)
                                                buttonOnOff.toggle()
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius:6)
                                                    .stroke(Color.blue, lineWidth: 1)
                                                    .frame(width: 70, height: 28)
                                                Text("팔로우")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.white)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                                                       
                            HStack {
                                Label {
                                    Text("파도")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.7))
                                } icon: {
                                    Text("\(profileVM.padoPosts.count + profileVM.sendPadoPosts.count)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                .font(.caption)
                                
                                NavigationLink(destination: FollowMainView(currentType: "팔로워", followVM: followVM, updateFollowData: updateFollowData, user: user)) {
                                    Label {
                                        Text("팔로워")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.7))
                                    } icon: {
                                        Text("\(followVM.followerIDs.count + followVM.surferIDs.count)")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    .font(.caption)
                                }
                                
                                NavigationLink(destination: FollowMainView(currentType: "팔로잉", followVM: followVM, updateFollowData: updateFollowData, user: user)) {
                                    Label {
                                        Text("팔로잉")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.7))
                                    } icon: {
                                        Text("\(followVM.followingIDs.count)")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.7))
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
                    Button {
                        dismiss()
                    } label: {
                        Image("dismissArrow")
                    }
                    
                    Spacer()
//                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 22))
//                    }
                }
                .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 70)
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
                        .foregroundStyle(profileVM.currentType == type ? .white : .gray)
                    
                    ZStack {
                        if profileVM.currentType == type {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.white)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        } else {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(.clear)
                        }
                    }
//                    .padding(.horizontal, 8)
                    .frame(height: 2)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        profileVM.currentType = type
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func postList() -> some View {
        switch profileVM.currentType {
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
            if profileVM.padoPosts.isEmpty {
                Text("아직 받은 게시물이 없어요")
                    .foregroundColor(.gray)
                    .font(.system(size: 16,
                                  weight: .semibold))
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(profileVM.padoPosts, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                KFImage(image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                    .clipped()
                            }
                            Text(post.title)
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                                .padding([.leading, .bottom], 5)
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 300)
        .padding(.top, 5)
    }
    
    @ViewBuilder
    func writtenPostsView() -> some View {
        VStack(spacing: 25) {
            if profileVM.sendPadoPosts.isEmpty {
                Text("아직 보낸 게시물이 없어요")
                    .foregroundColor(.gray)
                    .font(.system(size: 16,
                                  weight: .semibold))
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(profileVM.sendPadoPosts, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                KFImage(image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                    .clipped()
                            }
                            Text(post.title)
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                                .padding([.leading, .bottom], 5)
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 300)
        .padding(.top, 5)
    }
    
    @ViewBuilder
    func highlightsView() -> some View {
        VStack(spacing: 25) {
            if profileVM.highlights.isEmpty {
                Text("아직 좋아요를 표시한 게시물이 없어요")
                    .foregroundColor(.gray)
                    .font(.system(size: 16,
                                  weight: .semibold))
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(profileVM.highlights, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                KFImage(image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                    .clipped()
                            }
                            Text(post.title)
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                                .padding([.leading, .bottom], 5)
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 300)
        .padding(.top, 5)
    }
}
