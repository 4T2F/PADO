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
    @Environment(\.dismiss) var dismiss
    
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var followVM = FollowViewModel()
    @StateObject var postitVM = PostitViewModel()
    
    @Binding var buttonOnOff: Bool
    
    @Namespace var animation
    
    let user: User
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ProfileHeaderView(profileVM: profileVM,
                                  followVM: followVM,
                                  postitVM: postitVM,
                                  touchBackImage: $profileVM.touchBackImage,
                                  touchProfileImage: $profileVM.touchProfileImage,
                                  followerActive: $profileVM.followerActive,
                                  followingActive: $profileVM.followingActive,
                                  position: $profileVM.position,
                                  buttonOnOff: $buttonOnOff,
                                  user: user)
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
            .allowsHitTesting(!profileVM.touchBackImage)
            .allowsHitTesting(!profileVM.touchProfileImage)
            .opacity(profileVM.touchBackImage ? 0.1 : 1)
            .opacity(profileVM.touchProfileImage ? 0.1 : 1)
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
                                SocialMediaButton(platformName: "instagramicon",
                                                  urlScheme: "instagram://user?username=\(user.instaAddress)",
                                                  fallbackURL: "https://instagram.com/\(user.instaAddress)")
                            }
                            
                            if !user.tiktokAddress.isEmpty {
                                SocialMediaButton(platformName: "tiktokicon",
                                                  urlScheme: "tiktok://user?username=\(user.tiktokAddress)",
                                                  fallbackURL: "https://www.tiktok.com/@\(user.tiktokAddress)")
                            }
                            
                            if user.nameID != userNameID {
                                Button {
                                    if !userNameID.isEmpty {
                                        profileVM.isShowingUserReport = true
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                                .sheet(isPresented: $profileVM.isShowingUserReport) {
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
            if profileVM.touchBackImage {
                if let backProfileImageUrl = user.backProfileImageUrl {
                    UserProfileImageView(isTouched: $profileVM.touchBackImage,
                                         isDragging: $profileVM.isDragging,
                                         position: $profileVM.position,
                                         imageUrl: URL(string: backProfileImageUrl))
                }
            }
            // 프로필 사진 조건문
            if profileVM.touchProfileImage {
                if let profileImageUrl = user.profileImageUrl {
                    UserProfileImageView(isTouched: $profileVM.touchProfileImage,
                                         isDragging: $profileVM.isDragging,
                                         position: $profileVM.position,
                                         imageUrl: URL(string: profileImageUrl))
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
                profileVM.fetchingPostData = false
                await postitVM.listenForMessages(ownerID: user.nameID)
                postitVM.fetchedPostitData = true
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
            OtherUserPostGridView(profileVM: profileVM,
                                  isShowingDetail: $profileVM.isShowingReceiveDetail,
                                  posts: profileVM.padoPosts,
                                  fetchedData: profileVM.fetchedPadoData,
                                  isFetchingData: profileVM.fetchingPostData,
                                  text: "아직 받은 파도가 없어요.",
                                  postViewType: .receive,
                                  userID: user.nameID)
        case "보낸 파도":
            OtherUserPostGridView(profileVM: profileVM,
                                  isShowingDetail: $profileVM.isShowingSendDetail,
                                  posts: profileVM.sendPadoPosts,
                                  fetchedData: profileVM.fetchedSendPadoData,
                                  isFetchingData: profileVM.fetchingPostData,
                                  text: "아직 보낸 파도가 없어요.",
                                  postViewType: .send,
                                  userID: user.nameID)
        case "좋아요":
            if user.nameID != userNameID && user.openHighlight == "no" {
                NoItemView(itemName: "\(user.nameID)님이 좋아요를 표시한 파도는\n 비공개 상태입니다.")
                    .padding(.top, 150)
            } else {
                OtherUserPostGridView(profileVM: profileVM,
                                      isShowingDetail: $profileVM.isShowingHightlight,
                                      posts: profileVM.highlights,
                                      fetchedData: profileVM.fetchedHighlights,
                                      isFetchingData: profileVM.fetchingPostData,
                                      text: "아직 좋아요를 표시한 파도가 없어요.",
                                      postViewType: .receive,
                                      userID: user.nameID)
            }
        default:
            EmptyView()
        }
    }
}
