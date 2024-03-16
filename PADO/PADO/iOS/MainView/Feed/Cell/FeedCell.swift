//
//  FeedCell.swift
//  PADO
//
//  Created by 강치우 on 2/6/24.
//

import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import Lottie
import SwiftUI

struct FeedCell: View {
    @StateObject var feedCellVM = FeedCellViewModel()
    @ObservedObject var feedVM: FeedViewModel

    @Binding var post: Post
    
    var body: some View {
        ZStack {
            if feedCellVM.currentPadoRideIndex == nil || feedCellVM.padoRidePosts.isEmpty {
                Rectangle()
                    .foregroundStyle(.black)
                    .containerRelativeFrame([.horizontal,.vertical])
                    .overlay {
                        // MARK: - 사진
                        if let imageUrl = URL(string: post.imageUrl) {
                            ZStack {
                                KFImage.url(imageUrl)
                                    .resizable()
                                    .onSuccess { result in
                                        // 이미지 로딩 성공 시
                                        feedCellVM.isLoading = false
                                    }
                                    .onFailure { _ in
                                        // 이미지 로딩 실패 시
                                        feedCellVM.isLoading = false
                                    }
                                    .onProgress { receivedSize, totalSize in
                                        // 로딩 중
                                        feedCellVM.isLoading = true
                                    }
                                    .scaledToFill()
                                    .containerRelativeFrame([.horizontal,.vertical])
                            }
                            .overlay {
                                if feedCellVM.isHeaderVisible {
                                    LinearGradient(colors: [.black.opacity(0.5),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.1),
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .black.opacity(0.1),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.5)],
                                                   startPoint: .top,
                                                   endPoint: .bottom
                                    )
                                    .ignoresSafeArea()
                                }
                            }
                            
                            if feedCellVM.isLoading { // feedVM에서 로딩 상태를 관리한다고 가정
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
            } else if let currentIndex = feedCellVM.currentPadoRideIndex,
                      feedCellVM.padoRidePosts.indices.contains(currentIndex) {
                // PadoRide 이미지 표시
                let padoRide = feedCellVM.padoRidePosts[currentIndex]
                
                KFImage.url(URL(string: post.imageUrl))
                    .resizable()
                    .blur(radius: 50)
                    .containerRelativeFrame([.horizontal,.vertical])
                    .overlay {
                        // MARK: - 사진
                        if let imageUrl = URL(string: padoRide.imageUrl) {
                            ZStack {
                                KFImage.url(imageUrl)
                                    .resizable()
                                    .onSuccess { _ in
                                        // 이미지 로딩 성공 시
                                        feedCellVM.isLoading = false
                                    }
                                    .onFailure { _ in
                                        // 이미지 로딩 실패 시
                                        feedCellVM.isLoading = false
                                    }
                                    .onProgress { receivedSize, totalSize in
                                        // 로딩 중
                                        feedCellVM.isLoading = true
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.65)
                                    .cornerRadius(15)
                                    .scaledToFit()
                                    .containerRelativeFrame([.horizontal,.vertical])
                            }
                            .overlay {
                                if feedCellVM.isHeaderVisible {
                                    LinearGradient(colors: [.black.opacity(0.5),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.1),
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .clear, .clear,
                                                            .black.opacity(0.1),
                                                            .black.opacity(0.2),
                                                            .black.opacity(0.3),
                                                            .black.opacity(0.4),
                                                            .black.opacity(0.5)],
                                                   startPoint: .top,
                                                   endPoint: .bottom
                                    )
                                    .ignoresSafeArea()
                                }
                            }
                            
                            if feedCellVM.isLoading { // feedVM에서 로딩 상태를 관리한다고 가정
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    // MARK: - 아이디 및 타이틀
                    
                    VStack(alignment: .leading, spacing: 12) {
                        if feedCellVM.isHeaderVisible {
                            if !post.title.isEmpty {
                                Button {
                                    feedCellVM.isShowingMoreText.toggle()
                                } label: {
                                    if feedCellVM.isShowingMoreText {
                                        Text("\(post.title)")
                                            .font(.system(.subheadline))
                                            .fontWeight(.heavy)
                                            .foregroundStyle(.white)
                                            .padding(8)
                                            .background(.modal.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 3))
                                            .padding(.bottom, 4)
                                            .padding(.trailing, 24)
                                            .multilineTextAlignment(.leading)
                                    } else {
                                        Text("\(post.title)")
                                            .font(.system(.subheadline))
                                            .fontWeight(.heavy)
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                            .padding(8)
                                            .background(.modal.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 3))
                                            .padding(.bottom, 4)
                                            .padding(.trailing, 24)
                                    }
                                }
                                .lineSpacing(1)
                                .fontWeight(.bold)
                                .padding(.trailing, 20)
                            }
                            // MARK: - 서퍼
                            if let surferUser = feedCellVM.surferUser {
                                NavigationLink {
                                    OtherUserProfileView(buttonOnOff: $feedCellVM.postSurferButtonOnOff,
                                                         user: surferUser)
                                    
                                } label: {
                                    Text("surf. @\(post.surferUid)")
                                }
                                .font(.system(.callout))
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.modal.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .padding(.bottom, 4)
                                .padding(.trailing, 24)
                                
                            }
                        } else {
                            if let currentIndex = feedCellVM.currentPadoRideIndex {
                                Text("\(feedCellVM.padoRidePosts[currentIndex].id ?? "")님의 파도타기")
                                    .font(.system(.callout))
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .background(.modal.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                    .padding(.bottom, 4)
                                    .padding(.trailing, 24)
                            }
                        }
                        HStack(spacing: 12) {
                            
                            NavigationLink {
                                if let postUser = feedCellVM.postUser {
                                    OtherUserProfileView(buttonOnOff: $feedCellVM.postOwnerButtonOnOff,
                                                         user: postUser)
                                }
                            } label: {
                                if let postUser = feedCellVM.postUser {
                                    CircularImageView(size: .small,
                                                      user: postUser)
                                }
                            }
                            NavigationLink {
                                if let postUser = feedCellVM.postUser {
                                    OtherUserProfileView(buttonOnOff: $feedCellVM.postOwnerButtonOnOff,
                                                         user: postUser)
                                }
                            } label: {
                                HStack {
                                    if let user = feedCellVM.postUser {
                                        if !user.username.isEmpty {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(user.username)님의 프로필")
                                                    .font(.system(.footnote))
                                                    .fontWeight(.medium)
                                                
                                                Text("@\(post.ownerUid)")
                                                    .font(.system(.caption2))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.gray)
                                            }
                                        } else {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(post.ownerUid)님의 프로필")
                                                    .font(.system(.footnote))
                                                    .fontWeight(.medium)
                                                
                                                Text("@\(post.ownerUid)")
                                                    .font(.system(.caption2))
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                    Image(systemName: "chevron.right")
                                        .font(.system(.footnote))
                                        .foregroundStyle(.white)
                                        .padding(.leading, 90)
                                }
                                .padding(10)
                                .background(Color(.systemGray4).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 10) {
                            // MARK: - 멍게
                            VStack(spacing: 10) {
                                if post.padoExist ?? false {
                                    Button {
                                        withAnimation {
                                            // 햅틱 피드백 생성
                                            let generator = UIImpactFeedbackGenerator(style: .light)
                                            generator.impactOccurred()
                                            
                                            feedCellVM.touchPadoRideButton(postID: post.id ?? "")
                                        }
                                    } label: {
                                        Circle()
                                            .frame(width: 30)
                                            .foregroundStyle(.clear)
                                            .overlay {
                                                LottieView(animation: .named("button"))
                                                    .looping()
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 200, height: 200)
                                            }
                                    }
                                } else {
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundStyle(.clear)
                                }
                            }
                            .padding(.bottom, 15)
                            
                            
                            // MARK: - 하트
                            VStack(spacing: 10) {
                                if feedCellVM.isHeartCheck {
                                    Button {
                                        Task {
                                            await feedCellVM.touchDeleteHeart(post: post)
                                        }
                                    } label: {
                                        Circle()
                                            .frame(width: 24)
                                            .foregroundStyle(.clear)
                                            .overlay {
                                                LottieView(animation: .named("Heart"))
                                                    .playing()
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 65, height: 65)
                                            }
                                    }
                                } else {
                                    Button {
                                        Task {
                                            await feedCellVM.touchAddHeart(post: post)
                                        }
                                    } label: {
                                        Image("heart")
                                    }
                                    .sheet(isPresented: $feedCellVM.isShowingLoginPage, content: {
                                        StartView(isShowStartView: $feedCellVM.isShowingLoginPage)
                                            .presentationDragIndicator(.visible)
                                    })
                                }
                                
                                // MARK: - 하트 숫자
                                Button {
                                    if post.heartIDs.count > 1 {
                                        feedCellVM.isShowingHeartUserView = true
                                    }
                                } label: {
                                    Text("\(post.heartIDs.count-1)")
                                        .font(.system(.caption2))
                                        .fontWeight(.semibold)
                                        .shadow(radius: 1, y: 1)
                                }
                                .sheet(isPresented: $feedCellVM.isShowingHeartUserView, content: {
                                    HeartUsersView(userIDs: post.heartIDs)
                                })
                            }
                            
                            // MARK: - 댓글
                            NavigationLink {
                                if let postUser = feedCellVM.postUser,
                                   !feedCellVM.blockPost(post: post) {
                                    CommentView(postUser: postUser,
                                                post: post)
                                    
                                }
                            } label: {
                                VStack(spacing: 10) {
                                    Image("chat")
                                    
                                    // MARK: - 댓글 숫자
                                    Text("\(post.commentCount)")
                                        .font(.system(.caption2))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                        .shadow(radius: 1, y: 1)
                                }
                            }
                            
                            // MARK: - 신고하기
                            VStack(spacing: 10) {
                                Button {
                                    feedCellVM.touchReport(post: post)
                                } label: {
                                    VStack {
                                        Text("...")
                                            .font(.system(.largeTitle))
                                            .fontWeight(.regular)
                                            .foregroundStyle(.white)
                                        
                                        Text("")
                                    }
                                }
                                .sheet(isPresented: $feedCellVM.deletePadorideModal) {
                                    PostSelectModalView(title: "해당 파도타기를 삭제하시겠습니까?") {
                                        if let postID = post.id {
                                            await feedCellVM.deletePadoRide(index: feedCellVM.currentPadoRideIndex ?? 0,
                                                                      postID: postID)
                                        }
                                    }
                                    .presentationDetents([.fraction(0.4)])
                                }
                                
                                .sheet(isPresented: $feedCellVM.deleteSendPost) {
                                    PostSelectModalView(title: "해당 파도를 삭제하시겠습니까?") {
                                        await feedCellVM.deletePado(post: post)
                                    }
                                    .presentationDetents([.fraction(0.4)])
                                }
                                .sheet(isPresented: $feedCellVM.isShowingReportView) {
                                    ReportSelectView(isShowingReportView: $feedCellVM.isShowingReportView)
                                        .presentationDetents([.medium, .fraction(0.8)]) // 모달높이 조절
                                        .presentationDragIndicator(.visible)
                                }
                                .sheet(isPresented: $feedCellVM.isShowingLoginPage, content: {
                                    StartView(isShowStartView: $feedCellVM.isShowingLoginPage)
                                        .presentationDragIndicator(.visible)
                                })
                            }
                            .padding(.top, -15)
                        }
                    }
                }
            }
            .padding()
        }
        .onTapGesture(count: 2) {
            // 더블 탭 시 실행할 로직
            Task {
                if !feedCellVM.isHeartCheck {
                    await feedCellVM.touchAddHeart(post: post)
                }
            }
        }
        .onAppear {
            Task {
                await feedCellVM.fetchPostData(post: post)
            }
        }
    }
}
