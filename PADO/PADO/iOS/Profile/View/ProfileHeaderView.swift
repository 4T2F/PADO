//
//  ProfileHeaderView.swift
//  PADO
//
//  Created by 강치우 on 3/8/24.
//

import Kingfisher
import Lottie

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var postitVM: PostitViewModel
    
    @Binding var touchBackImage: Bool
    @Binding var touchProfileImage: Bool
    @Binding var followerActive: Bool
    @Binding var followingActive: Bool
    @Binding var position: CGSize
    @Binding var buttonOnOff: Bool
    
    var user: User
    
    var body: some View {
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
                                        profileVM.isShowingMessageView = true
                                    } label: {
                                        Circle()
                                            .frame(width: 30)
                                            .foregroundStyle(.clear)
                                            .overlay {
                                                if postitVM.messages.isEmpty {
                                                    LottieView(animation: .named(LottieType.nonePostit.rawValue))
                                                        .paused(at: .progress(1))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                } else {
                                                    LottieView(animation: .named(LottieType.postIt.rawValue))
                                                        .looping()
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                }
                                            }
                                    }
                                    .offset(x: 46, y: -40)
                                    .sheet(isPresented: $profileVM.isShowingMessageView) {
                                        PostitView(postitVM: postitVM,
                                                   isShowingMessageView: $profileVM.isShowingMessageView)
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
                                        Text(userNameID)
                                            .font(.system(.body))
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                Spacer()
                                
                                if user.nameID == userNameID {
                                    NavigationLink(destination: {
                                        SettingProfileView()
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius:4)
                                                .stroke(Color.white, lineWidth: 1)
                                                .frame(width: 80, height: 28)
                                            Text("프로필 편집")
                                                .font(.system(size: 12))
                                                .fontWeight(.medium)
                                                .foregroundStyle(.white)
                                        }
                                    })
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
}
