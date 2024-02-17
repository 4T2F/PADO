//
//  OtherUserProfileView.swift
//  PADO
//
//  Created by 최동호 on 2/2/24.
//

import Kingfisher
import Lottie
import PopupView
import SwiftUI

struct OtherUserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var followVM = FollowViewModel()
    @StateObject var postitVM = PostitViewModel()
    @StateObject var feedVM = FeedViewModel()
    @Namespace var animation
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var buttonOnOff: Bool
    @State private var buttonActive: Bool = false
    @State private var profileEditButtonActive: Bool = false
    @State private var followerActive: Bool = false
    @State private var followingActive: Bool = false
    
    @State private var isShowingReceiveDetail: Bool = false
    @State private var isShowingSendDetail: Bool = false
    @State private var isShowingHightlight: Bool = false
    @State private var isShowingMessageView: Bool = false
    @State private var isShowingUserReport: Bool = false
    @State private var touchProfileImage: Bool = false
    @State private var touchBackImage: Bool = false
    
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
        .navigationTitle("@\(user.nameID)")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    HStack(spacing: 0) {
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
                        
                        if user.nameID == userNameID {
                            NavigationLink {
                                SettingView(profileVM: profileVM)
                            } label: {
                                Image("more")
                                    .foregroundStyle(.white)
                            }
                        } else {
                            Button {
                                isShowingUserReport.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                            .sheet(isPresented: $isShowingUserReport) {
                                ReprotProfileModalView(profileVM: profileVM, user: user)
                                    .presentationDetents([.fraction(0.33)])
                                    .presentationDragIndicator(.visible)
                                    .presentationCornerRadius(30)
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
                await followVM.initializeFollowFetch(id: user.nameID)
                await profileVM.fetchPostID(id: user.nameID)
                await postitVM.getMessageDocument(ownerID: user.nameID)
            }
        }
        .popup(isPresented: $touchBackImage) {
            TouchBackImageView(user: user)
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $touchProfileImage) {
            TouchProfileView(user: user)
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
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
                            CircularImageView(size: .xxLarge, user: user)
                                .offset(y: 5)
                                .onTapGesture {
                                    touchProfileImage = true
                                }
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
                                        .presentationDragIndicator(.visible)
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
                                    NavigationLink {
                                        SettingProfileView()
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
                                } else {
                                    FollowButtonView(cellUserId: user.nameID,
                                                     buttonActive: $buttonOnOff,
                                                     activeText: "팔로우",
                                                     unActiveText: "팔로우 취소",
                                                     widthValue: 85,
                                                     heightValue: 28,
                                                     buttonType: ButtonType.direct)
                                }
                            }
                            
                            HStack {
                                HStack(spacing: 2) {
                                    Text("\(profileVM.padoPosts.count + profileVM.sendPadoPosts.count)")
                                    
                                    Text("wave")
                                }
                                .font(.callout)
                                .foregroundStyle(.white.opacity(0.9))
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                
                                Button {
                                    followerActive = true
                                } label: {
                                    HStack(spacing: 2) {
                                        Text("\(followVM.followerIDs.count + followVM.surferIDs.count)")
                                        
                                        Text("follower")
                                    }
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.9))
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                }
                                .sheet(isPresented: $followerActive) {
                                    FollowMainView(currentType: "팔로워", followVM: followVM, user: user)
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                        .onDisappear {
                                            followerActive = false
                                        }
                                }
                                
                                Button {
                                    followingActive = true
                                } label: {
                                    HStack(spacing: 2) {
                                        Text("\(followVM.followingIDs.count)")
                                        
                                        Text("following")
                                    }
                                    .font(.callout)
                                    .foregroundStyle(.white.opacity(0.9))
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                }
                                
                                .sheet(isPresented: $followingActive) {
                                    FollowMainView(currentType: "팔로잉",
                                                   followVM: followVM,
                                                   user: user)
                                    .presentationDetents([.large])
                                    .presentationDragIndicator(.visible)
                                    .onDisappear {
                                        followingActive = false
                                    }
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
                .onTapGesture {
                    touchBackImage = true
                }
        }
        .frame(height: 300)
    }
    
    @ViewBuilder
    func pinnedHeaderView() -> some View {
        let types: [String] = ["받은 파도", "보낸 파도", "하이라이트"]
        HStack(spacing: 25) {
            ForEach(types, id: \.self) { type in
                VStack(spacing: 12) {
                    Text(type)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
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
        .padding(.top, 15)
        .padding(.horizontal)
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
                NoItemView(itemName: "아직 받은 게시물이 없어요")
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(profileVM.padoPosts, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                Button {
                                    isShowingReceiveDetail.toggle()
                                    if let postID = post.id {
                                        profileVM.selectedPostID = postID
                                    }
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingReceiveDetail) {
                                    SelectPostView(profileVM: profileVM,
                                                   feedVM: feedVM,
                                                   viewType: PostViewType.receive,
                                                   isShowingDetail: $isShowingReceiveDetail)
                                    .presentationDragIndicator(.visible)
                                    .onDisappear {
                                        feedVM.currentPadoRideIndex = nil
                                        feedVM.isShowingPadoRide = false
                                        feedVM.padoRidePosts = []
                                    }
                                }
                                
                            }
                            
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 500)
        .offset(y: -4)
    }
    
    @ViewBuilder
    func writtenPostsView() -> some View {
        VStack(spacing: 25) {
            if profileVM.sendPadoPosts.isEmpty {
                NoItemView(itemName: "아직 보낸 게시물이 없어요")
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(profileVM.sendPadoPosts, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                Button {
                                    isShowingSendDetail.toggle()
                                    if let postID = post.id {
                                        profileVM.selectedPostID = postID
                                    }
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingSendDetail) {
                                    SelectPostView(profileVM: profileVM,
                                                   feedVM: feedVM,
                                                   viewType: PostViewType.send,
                                                   isShowingDetail: $isShowingSendDetail)
                                    .presentationDragIndicator(.visible)
                                    .onDisappear {
                                        feedVM.currentPadoRideIndex = nil
                                        feedVM.isShowingPadoRide = false
                                        feedVM.padoRidePosts = []
                                    }
                                }
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 500)
        .offset(y: -4)
    }
    
    @ViewBuilder
    func highlightsView() -> some View {
        VStack(spacing: 25) {
            if profileVM.highlights.isEmpty {
                NoItemView(itemName: "아직 좋아요를 표시한 게시물이 없어요")
                    .padding(.top, 150)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(profileVM.highlights, id: \.self) { post in
                        ZStack(alignment: .bottomLeading) {
                            if let image = URL(string: post.imageUrl) {
                                Button {
                                    isShowingHightlight.toggle()
                                    if let postID = post.id {
                                        profileVM.selectedPostID = postID
                                    }
                                } label: {
                                    KFImage(image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                        .clipped()
                                }
                                .sheet(isPresented: $isShowingHightlight) {
                                    SelectPostView(profileVM: profileVM,
                                                   feedVM: feedVM,
                                                   viewType: PostViewType.highlight,
                                                   isShowingDetail: $isShowingHightlight)
                                    .presentationDragIndicator(.visible)
                                    .onDisappear {
                                        feedVM.currentPadoRideIndex = nil
                                        feedVM.isShowingPadoRide = false
                                        feedVM.padoRidePosts = []
                                    }
                                }
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                    }
                }
            }
        }
        .padding(.bottom, 500)
        .offset(y: -4)
    }
}
