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
    @Environment(\.dismiss) var dismiss
    
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var followVM = FollowViewModel()
    @StateObject var postitVM = PostitViewModel()
    @StateObject var feedVM = FeedViewModel()
    
    @State private var buttonActive: Bool = false
    @State private var profileEditButtonActive: Bool = false
    @State private var followerActive: Bool = false
    @State private var followingActive: Bool = false
    
    @State private var isShowingReceiveDetail: Bool = false
    @State private var isShowingSendDetail: Bool = false
    @State private var isShowingHightlight: Bool = false
    @State private var isShowingMessageView: Bool = false
    @State private var isShowingUserReport: Bool = false
    @State private var fetchedPostitData: Bool = false
    @State private var touchProfileImage: Bool = false
    @State private var touchBackImage: Bool = false
    @State private var fetchingPostData: Bool = true
    @State private var position = CGSize.zero
    @State private var isDragging = false
    
    @Binding var buttonOnOff: Bool
    
    @Namespace var animation
    
    let user: User
    let columns = [GridItem(.flexible(), spacing: 1), 
                   GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                headerView()
                    .padding(.top, 50)
                VStack(spacing: 0) {
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
            .allowsHitTesting(!touchBackImage)
            .allowsHitTesting(!touchProfileImage)
            .opacity(touchBackImage ? 0.1 : 1)
            .opacity(touchProfileImage ? 0.1 : 1)
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
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            
                            Text("뒤로")
                                .font(.system(.body))
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
                            
                            if user.nameID != userNameID {
                                Button {
                                    if !userNameID.isEmpty {
                                        isShowingUserReport = true
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                                .sheet(isPresented: $isShowingUserReport) {
                                    ReprotProfileModalView(profileVM: profileVM, user: user)
                                        .presentationDetents([.fraction(0.3)])
                                        .presentationDragIndicator(.visible)
                                        .presentationCornerRadius(30)
                                }
                            }
                        }
                    }
                }
            }
            
            // 뒷배경 조건문
            if touchBackImage {
                if let backProfileImageUrl = user.backProfileImageUrl {
                    KFImage(URL(string: backProfileImageUrl))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: isDragging ? 12 : 0))
                        .zIndex(2)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.touchBackImage = false
                            }
                        }
                        .offset(position)
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged({ value in
                                    self.position = value.translation
                                    self.isDragging = true
                                })
                                .onEnded({ value in
                                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        if 200 < abs(self.position.height) {
                                            self.touchBackImage = false
                                            self.isDragging = false
                                        } else {
                                            self.position = .zero
                                            self.isDragging = false
                                        }
                                    }
                                })
                        )
                }
            }
            // 프로필 사진 조건문
            if touchProfileImage {
                if let profileImageUrl = user.profileImageUrl {
                    KFImage(URL(string: profileImageUrl))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: isDragging ? 12 : 0))
                        .zIndex(2)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                                self.touchProfileImage = false
                            }
                        }
                        .offset(position)
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged({ value in
                                    self.position = value.translation
                                    self.isDragging = true
                                })
                                .onEnded({ value in
                                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        if 200 < abs(self.position.height) {
                                            self.touchProfileImage = false
                                            self.isDragging = false
                                        } else {
                                            self.position = .zero
                                            self.isDragging = false
                                        }
                                    }
                                })
                        )
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
                await profileVM.fetchPostID(user: user)
                fetchingPostData = false
                await postitVM.listenForMessages(ownerID: user.nameID)
                fetchedPostitData = true
                enteredNavigation = true
            }
        }
        .onChange(of: resetNavigation) { _, _ in
            dismiss()
        }
        .onDisappear {
            followVM.stopAllListeners()
            postitVM.removeListner()
            profileVM.stopAllPostListeners()
            enteredNavigation = false
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            KFImage(URL(string: user.backProfileImageUrl ?? defaultBackgroundImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.clear,
                                                .main.opacity(0.1),
                                                .main.opacity(0.3),
                                                .main.opacity(0.5),
                                                .main.opacity(0.8),
                                                .main.opacity(1)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            CircularImageView(size: .xxxLarge, user: user)
                                .zIndex(touchProfileImage ? 1 : 0)
                                .onTapGesture {
                                    if user.profileImageUrl != nil {
                                        position = .zero
                                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                                            touchProfileImage = true
                                        }
                                    }
                                }
                                .overlay {
                                    Button {
                                        if fetchedPostitData {
                                            isShowingMessageView = true
                                        }
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
                                    .offset(x: 46, y: -40)
                                    .sheet(isPresented: $isShowingMessageView) {
                                        PostitView(postitVM: postitVM,
                                                   isShowingMessageView: $isShowingMessageView)
                                        .presentationDragIndicator(.visible)
                                    }
                                    .presentationDetents([.large])
                                }
                            
                            
                            HStack(alignment: .center, spacing: 4) {
                                VStack(alignment: .leading, spacing: 4) {
                                    if !user.username.isEmpty {
                                        Text(user.username)
                                            .font(.system(.body))
                                            .fontWeight(.semibold)
                                    } else {
                                        Text(user.nameID)
                                            .font(.system(.body))
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                Spacer()
                                
                                if user.nameID == userNameID {
                                    Button {
                                        Task {
                                            dismiss()
                                            try? await Task.sleep(nanoseconds: 1 * 500_000_000)
                                            viewModel.showTab = 4
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius:4)
                                                .stroke(Color.white, lineWidth: 1)
                                                .frame(width: 80, height: 28)
                                            Text("내 프로필")
                                                .font(.system(.footnote))
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                } else {
                                    FollowButtonView(buttonActive: $buttonOnOff, 
                                                     cellUser: user,
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
                                    
                                    Text("파도")
                                        .fontWeight(.medium)
                                }
                                .font(.system(.body))
                                .foregroundStyle(.white)
                                
                                Button {
                                    followerActive = true
                                } label: {
                                    HStack(spacing: 2) {
                                        Text("\(followVM.followerIDs.count + followVM.surferIDs.count)")
                                        
                                        Text("팔로워")
                                            .fontWeight(.medium)
                                    }
                                    .font(.system(.body))
                                    .foregroundStyle(.white)
                                }
                                .sheet(isPresented: $followerActive) {
                                    FollowMainView(followVM: followVM, 
                                                   currentType: "팔로워",
                                                   user: user)
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
                                        
                                        Text("팔로잉")
                                            .fontWeight(.medium)
                                    }
                                    .font(.system(.body))
                                    .foregroundStyle(.white)
                                }
                                
                                .sheet(isPresented: $followingActive) {
                                    FollowMainView(followVM: followVM, 
                                                   currentType: "팔로잉",
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
                .zIndex(touchBackImage ? 1 : 0)
                .onTapGesture {
                    if user.backProfileImageUrl != nil {
                        position = .zero
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                            touchBackImage = true
                        }
                    }
                }
        }
        .frame(height: 300)
    }
    
    @ViewBuilder
    func pinnedHeaderView() -> some View {
        let types: [String] = ["받은 파도", "보낸 파도", "좋아요"]
        HStack(spacing: 25) {
            ForEach(types, id: \.self) { type in
                VStack(spacing: 12) {
                    Text(type)
                        .font(.system(.headline))
                        .fontWeight(.medium)
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
        .padding(.top, 4)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func postList() -> some View {
        switch profileVM.currentType {
        case "받은 파도":
            postView()
        case "보낸 파도":
            writtenPostsView()
        case "좋아요":
            highlightsView()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func postView() -> some View {
        VStack(spacing: 25) {
            if fetchingPostData {
                LottieView(animation: .named("Loading"))
                    .looping()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 60)
            } else if profileVM.padoPosts.isEmpty {
                NoItemView(itemName: "아직 받은 게시물이 없습니다")
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
                                                   isShowingDetail: $isShowingReceiveDetail,
                                                   userID: user.nameID,
                                                   viewType: PostViewType.receive)
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
                    if profileVM.fetchedPadoData {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .onAppear {
                                Task {
                                    try? await Task.sleep(nanoseconds: 1 * 1000_000_000)
                                    await profileVM.fetchMorePadoPosts(id: userNameID)
                                }
                            }
                    }
                }
            }
        }
        .offset(y: -4)
    }
    
    @ViewBuilder
    func writtenPostsView() -> some View {
        VStack(spacing: 25) {
            if fetchingPostData {
                LottieView(animation: .named("Loading"))
                    .looping()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 60)
            } else if profileVM.sendPadoPosts.isEmpty {
                NoItemView(itemName: "아직 보낸 게시물이 없습니다")
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
                                                   isShowingDetail: $isShowingSendDetail,
                                                   userID: user.nameID,
                                                   viewType: PostViewType.send)
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
                    if profileVM.fetchedSendPadoData {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .onAppear {
                                Task {
                                    try? await Task.sleep(nanoseconds: 1 * 1000_000_000)
                                    await profileVM.fetchMoreSendPadoPosts(id: userNameID)
                                }
                            }
                    }
                }
            }
        }
        .offset(y: -4)
    }
    
    @ViewBuilder
    func highlightsView() -> some View {
        VStack(spacing: 25) {
            if fetchingPostData {
                LottieView(animation: .named("Loading"))
                    .looping()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 60)
            } else if user.nameID != userNameID
                        && user.openHighlight == "no" {
                NoItemView(itemName: "\(user.nameID)님이 좋아요를 표시한 파도는\n 비공개 입니다")
                    .padding(.top, 150)
            } else if profileVM.highlights.isEmpty {
                NoItemView(itemName: "아직 좋아요를 표시한 게시물이 없습니다")
                    .padding(.top, 150)
            }  else {
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
                                                   isShowingDetail: $isShowingHightlight,
                                                   userID: user.nameID,
                                                   viewType: PostViewType.highlight)
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
                    if profileVM.fetchedHighlights {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .onAppear {
                                Task {
                                    try? await Task.sleep(nanoseconds: 1 * 1000_000_000)
                                    await profileVM.fetchMoreHighlihts(id: userNameID)
                                }
                            }
                    }
                }
            }
        }
        .offset(y: -4)
    }
}
