//
//  Spotify.swift
//  Components
//
//  Created by 강치우 on 1/30/24.
//

import Kingfisher
import Lottie
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var postitVM: PostitViewModel
    
    @State var openHighlight: Bool = false
    @State private var isShowingReceiveDetail: Bool = false
    @State private var isShowingSendDetail: Bool = false
    @State private var isShowingHightlight: Bool = false
    @State private var touchProfileImage: Bool = false
    @State private var touchBackImage: Bool = false
    @State private var isDragging = false
    @State private var position = CGSize.zero
    @State private var isRefresh: Bool = false
    @State private var buttonOnOff: Bool = false
    
    @State private var followerActive: Bool = false
    @State private var followingActive: Bool = false
    
    @Binding var fetchedPostitData: Bool
    
    @Namespace var animation
    
    let user: User
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ProfileHeaderView(touchBackImage: $touchBackImage,
                                      touchProfileImage: $touchProfileImage,
                                      followerActive: $followerActive,
                                      followingActive: $followingActive,
                                      position: $position,
                                      buttonOnOff: $buttonOnOff, 
                                      user: user,
                                      profileVM: profileVM,
                                      followVM: followVM,
                                      postitVM: postitVM)
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
                        .background(.main)
                    }
                }
                .refreshable(action: {
                    Task {
                        isRefresh = true
                        if let currentUser = viewModel.currentUser {
                            profileVM.stopAllPostListeners()
                            try? await Task.sleep(nanoseconds: 1 * 1000_000_000)
                            await profileVM.fetchPostID(user: currentUser)
                        }
                        isRefresh = false
                    }
                })
                .background(.main, ignoresSafeAreaEdges: .all)
                .allowsHitTesting(!touchBackImage)
                .allowsHitTesting(!touchProfileImage)
                .opacity(touchBackImage ? 0.1 : 1)
                .opacity(touchProfileImage ? 0.1 : 1)
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if viewModel.currentUser?.openHighlight == nil || viewModel.currentUser?.openHighlight == "yes" {
                        openHighlight = true
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("@\(userNameID)")
                            .font(.system(.title2))
                            .fontWeight(.bold)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                if !user.instaAddress.isEmpty {
                                    SocialMediaButton(platformName: "instagramicon", 
                                                      urlScheme: "instagram://user?username=\(user.instaAddress)",
                                                      fallbackURL: "https://instagram.com/\(user.instaAddress)")
                                }
                                
                                if !user.tiktokAddress.isEmpty {
                                    SocialMediaButton(platformName: "tiktokicon", 
                                                      urlScheme: "tiktok://user?username=\(user.tiktokAddress)",
                                                      fallbackURL: "https://www.tiktok.com/@\(user.tiktokAddress)")
                                }
                            }
                            
                            NavigationLink {
                                SettingView(profileVM: profileVM,
                                            openHighlight: $openHighlight)
                            } label: {
                                Image("more")
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                // 뒷배경 조건문
                if touchBackImage {
                    if let backProfileImageUrl = user.backProfileImageUrl {
                        UserProfileImageView(isTouched: $touchBackImage,
                                             isDragging: $isDragging,
                                             position: $position,
                                             imageUrl: URL(string: backProfileImageUrl))
                    }
                }
                // 프로필 사진 조건문
                if touchProfileImage {
                    if let profileImageUrl = user.profileImageUrl {
                        UserProfileImageView(isTouched: $touchProfileImage,
                                             isDragging: $isDragging,
                                             position: $position,
                                             imageUrl: URL(string: profileImageUrl))
                    }
                }
                
                VStack {
                    if isRefresh {
                        LottieView(animation: .named("Wave"))
                            .looping()
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top, 30)
                    }
                    Spacer()
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
            .navigationDestination(isPresented: $viewModel.showingProfileView) {
                SettingProfileView()
            }
        }
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
            PostGridView(isShowingDetail: $isShowingReceiveDetail,
                         profileVM: profileVM,
                         feedVM: feedVM, 
                         text: "아직 받은 파도가 없어요.",
                         posts: profileVM.padoPosts,
                         fetchedData: profileVM.fetchedPadoData,
                         postViewType: .receive)
        case "보낸 파도":
            PostGridView(isShowingDetail: $isShowingSendDetail,
                         profileVM: profileVM,
                         feedVM: feedVM, 
                         text: "아직 보낸 파도가 없어요.",
                         posts: profileVM.sendPadoPosts,
                         fetchedData: profileVM.fetchedSendPadoData,
                         postViewType: .send)
        case "좋아요":
            PostGridView(isShowingDetail: $isShowingHightlight,
                         profileVM: profileVM,
                         feedVM: feedVM, 
                         text: "아직 좋아요를 누른 게시글이 없어요.",
                         posts: profileVM.highlights,
                         fetchedData: profileVM.fetchedHighlights,
                         postViewType: .highlight)
        default:
            EmptyView()
        }
    }
}
