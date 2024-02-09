//
//  OtherUserProfileView.swift
//  PADO
//
//  Created by 최동호 on 2/2/24.
//

import Kingfisher
import Lottie
import SwiftUI

struct OtherUserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var followVM = FollowViewModel()
    @StateObject var postitVM = PostitViewModel()
    @Namespace var animation
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var buttonOnOff: Bool
    @State private var buttonActive: Bool = false
    @State private var profileEditButtonActive: Bool = false
    
    @State private var isShowingReceiveDetail: Bool = false
    @State private var isShowingSendDetail: Bool = false
    @State private var isShowingHightlight: Bool = false
    @State private var isShowingMessageView: Bool = false
    
    @State private var selectedPostID: String?
    
    let updateFollowData: UpdateFollowData
    let updatePushNotiData = UpdatePushNotiData()
    
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
                            .background(Color.main)
                            .modifier(OffsetModifier(offset: $profileVM.headerOffsets.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $profileVM.headerOffsets.1))
                    }
                }
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("@\(user.nameID)")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    HStack(spacing: 6) {
                        if !user.instaAddress.isEmpty {
                            Button {
                                profileVM.openSocialMediaApp(urlScheme: "instagram://user?username=\(user.instaAddress)", fallbackURL: "https://instagram.com/\(user.instaAddress)")
                            } label: {
                                Image("instagramicon")
                            }
                        }
                        
                        if !user.tiktokAddress.isEmpty {
                            Button {
                                profileVM.openSocialMediaApp(urlScheme: "tiktok://user?username=\(user.tiktokAddress)", fallbackURL: "https://www.tiktok.com/@\(user.tiktokAddress)")
                            } label: {
                                Image("tiktokicon")
                            }
                        }
                    }
                }
            }
        }
        .overlay {
            Rectangle()
                .fill(.main)
                .frame(height: 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(profileVM.headerOffsets.0 < 5 ? 1 : 0)
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
        .onAppear {
            Task {
                followVM.profileFollowId = user.nameID
                followVM.initializeFollowFetch()
                await profileVM.fetchPostID(id: user.nameID)
                await postitVM.getMessageDocument(ownerID: user.nameID)
            }
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            RectangleImageView(imageUrl: user.backProfileImageUrl)
                .scaledToFill()
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.clear,
                                                .main.opacity(0.1),
                                                .main.opacity(0.3),
                                                .main.opacity(0.5),
                                                .main.opacity(0.8),
                                                .main.opacity(1)], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            CircularImageView(size: .xLarge, user: user)
                                .offset(y: 5)
                                .overlay {
                                    Button {
                                        isShowingMessageView = true
                                    } label: {
                                        Circle()
                                            .frame(width: 30)
                                            .foregroundStyle(.clear)
                                            .overlay {
                                                if postitVM.messages.isEmpty {
                                                    LottieView(animation: .named("nonePostit"))
                                                        .paused(at: .progress(1))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                } else {
                                                    LottieView(animation: .named("Postit"))
                                                        .looping()
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                }
                                            }
                                    }
                                    .offset(x: +46, y: -30)
                                    .sheet(isPresented: $isShowingMessageView) {
                                        
                                        PostitView(postitVM: postitVM,
                                                   isShowingMessageView: $isShowingMessageView)
                                        
                                    }
                                    .presentationDetents([.large])
                                }
                            
                            
                            HStack(alignment: .center, spacing: 5) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.username)
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                                
                                if user.nameID == userNameID {
                                    Button {
                                        profileEditButtonActive = true
                                    } label: {
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
                                    .sheet(isPresented: $profileEditButtonActive) {
                                        SettingProfileView()
                                            .onDisappear {
                                                profileEditButtonActive = false
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
                                                    .stroke(.gray, lineWidth: 1)
                                                    .frame(width: 85, height: 28)
                                                Text("팔로우 취소")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    } else {
                                        Button {
                                            Task {
                                                await updateFollowData.followUser(id: user.nameID)
                                                await updatePushNotiData.pushNoti(receiveUser: user, type: .follow)
                                                buttonOnOff.toggle()
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius:6)
                                                    .stroke(.white, lineWidth: 1)
                                                    .frame(width: 85, height: 28)
                                                Text("팔로우")
                                                    .font(.system(size: 12))
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
                                        .foregroundStyle(.white.opacity(0.9))
                                } icon: {
                                    Text("\(profileVM.padoPosts.count + profileVM.sendPadoPosts.count)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                .font(.callout)
                                
                                NavigationLink(destination: FollowMainView(currentType: "팔로워", followVM: followVM, updateFollowData: updateFollowData, user: user)) {
                                    Label {
                                        Text("팔로워")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.9))
                                    } icon: {
                                        Text("\(followVM.followerIDs.count + followVM.surferIDs.count)")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.9))
                                    }
                                    .font(.callout)
                                }
                                
                                NavigationLink(destination: FollowMainView(currentType: "팔로잉", followVM: followVM, updateFollowData: updateFollowData, user: user)) {
                                    Label {
                                        Text("팔로잉")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.9))
                                    } icon: {
                                        Text("\(followVM.followingIDs.count)")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.9))
                                    }
                                    .font(.callout)
                                }
                            }
                            .padding(.leading, 2)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .cornerRadius(0)
                .offset(y: -minY)
        }
        .frame(height: 250)
    }
    
    @ViewBuilder
    func pinnedHeaderView() -> some View {
        let types: [String] = ["받은 파도", "보낸 파도", "하이라이트"]
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
                    .frame(height: 1)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .frame(width: UIScreen.main.bounds.width, height: 0.5)
                            .foregroundStyle(Color(.systemGray2))
                    }
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
        .padding(.top, 15)
    }
    
    @ViewBuilder
    func postList() -> some View {
        switch profileVM.currentType {
        case "받은 파도":
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
                                Button {
                                    isShowingReceiveDetail.toggle()
                                    self.selectedPostID = post.id
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingReceiveDetail) {
                                    OtherSelectPostView(profileVM: profileVM,
                                                        viewType: PostViewType.receive,
                                                        isShowingDetail: $isShowingReceiveDetail,
                                                        selectedPostID: selectedPostID ?? "")
                                    .presentationDragIndicator(.visible)
                                }
                                
                            }
                            
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 500)
        .offset(y: -6)
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
                                Button {
                                    isShowingSendDetail.toggle()
                                    self.selectedPostID = post.id
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingSendDetail) {
                                    OtherSelectPostView(profileVM: profileVM,
                                                        viewType: PostViewType.send,
                                                        isShowingDetail: $isShowingSendDetail,
                                                        selectedPostID: selectedPostID ?? "")
                                    .presentationDragIndicator(.visible)
                                }
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 500)
        .offset(y: -6)
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
                                Button {
                                    isShowingHightlight.toggle()
                                    self.selectedPostID = post.id
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingHightlight) {
                                    OtherSelectPostView(profileVM: profileVM,
                                                        viewType: PostViewType.highlight,
                                                        isShowingDetail: $isShowingHightlight,
                                                        selectedPostID: selectedPostID ?? "")
                                    .presentationDragIndicator(.visible)
                                }
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 500)
        .offset(y: -6)
    }
}
