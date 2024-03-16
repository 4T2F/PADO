//
//  ContentView.swift
//  PADO
//
//  Created by 최동호 on 1/2/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var surfingVM = SurfingViewModel()
    @StateObject var feedVM = FeedViewModel()
    @StateObject var followVM = FollowViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var postitVM = PostitViewModel()
    @StateObject var notiVM = NotificationViewModel()
    
    @State var fetchedPostitData: Bool = false
    @State var width = UIScreen.main.bounds.width
    @State private var showPushProfile = false
    @State private var pushUser: User?
    @State private var showPushPost = false
    @State private var pushPostID: String = ""
    @State private var showPushPostit = false
    @State private var keyboardHeight: CGFloat = 0
    
    let updateHeartData = UpdateHeartData()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $viewModel.showTab) {
            FeedView(feedVM: feedVM, notiVM: notiVM,
                     delegate: self)
            .tag(0)
            
            MainSearchView(profileVM: profileVM)
            .tag(1)
            
            if let user = viewModel.currentUser {
                SurfingView(surfingVM: surfingVM,
                            feedVM: feedVM,
                            followVM: followVM)
                .tag(2)
                
                PadoRideView(feedVM: feedVM,
                             surfingIDs: followVM.surfingIDs)
                .tag(3)
                
                ProfileView(profileVM: profileVM,
                            followVM: followVM,
                            feedVM: feedVM,
                            postitVM: postitVM,
                            user: user)
                .tag(4)
            } else {
                LoginAlert()
                    .tag(2)
                
                LoginAlert()
                    .tag(3)
                
                LoginAlert()
                    .tag(4)
            }
        }
        .overlay(alignment: .bottom){
            CustomTabView()
                .offset(y: keyboardHeight > 0 ? UIScreen.main.bounds.height : 0)
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardHeight = keyboardFrame.height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 0
            }
        }
        // 상대방 프로필로 전환 이벤트(팔로우, 서퍼지정, 방명록 글)
        .sheet(isPresented: $showPushProfile) {
            if let user = pushUser {
                NavigationStack {
                    OtherUserProfileView(buttonOnOff: .constant(true), user: user)
                        .presentationDragIndicator(.visible)
                }
            }
        }
        .sheet(isPresented: $showPushPost) {
            if let post = notiVM.notiPosts[pushPostID] {
                FeedCell(feedVM: feedVM,
                               post: .constant(post))
                .presentationDragIndicator(.visible)
            }

        }
        .tint(.white)
        .onAppear {
            fetchData()
        }
        .onChange(of: needsDataFetch) { _, _ in
            fetchData()
        }
        .onChange(of: pushUser) { }
        .onChange(of: pushPostID) { } 
    }
}

// MARK: 비즈니스 로직
extension ContentView {
    func fetchData() {
        guard !userNameID.isEmpty else {
            Task {
                fetchedPostitData = false
                viewModel.selectedFilter = .today
                viewModel.showTab = 0
                await feedVM.getPopularUser()
                feedVM.followingPosts.removeAll()
                await feedVM.fetchTodayPadoPosts()
                profileVM.stopAllPostListeners()
                viewModel.showLaunchScreen = false
            }
            return
        }
        
        Task {
            viewModel.selectedFilter = .following
            viewModel.showTab = 0
            feedVM.postFetchLoading = true
            fetchedPostitData = false
            await profileVM.fetchBlockUsers()
            await followVM.initializeFollowFetch(id: userNameID)
            await feedVM.fetchTodayPadoPosts()
            await feedVM.fetchFollowingPosts()
            profileVM.stopAllPostListeners()
            await profileVM.fetchPostID(user: viewModel.currentUser!)
            
            await postitVM.listenForMessages(ownerID: userNameID)
            fetchedPostitData = true
            await notiVM.fetchNotifications()
            feedVM.postFetchLoading = false
            viewModel.showLaunchScreen = false
            
            NotificationCenter.default.addObserver(forName: Notification.Name("ProfileNotification"), object: nil, queue: .main) { notification in
                // 팔로잉, 서퍼지정 알림을 받았을 때 수행할 작업
                guard let notiUserID = notification.object as? String else { return }
                
                Task {
                    await handleProfileNotification(notiUserID: notiUserID)
                }
            }
            
            NotificationCenter.default.addObserver(forName: Notification.Name("PostNotification"), object: nil, queue: .main) { notification in
                // 댓글, 하트, 포토모지, 파도타기, 게시물 작성 알림을 받았을 때 수행할 작업
                guard let notiPostID = notification.object as? String else { return }
                
                Task {
                    await handlePostNotification(notiPostID: notiPostID)
                }
            }
            
            NotificationCenter.default.addObserver(forName: Notification.Name("PostitNotification"), object: nil, queue: .main) { notification in
                // 포스트잇 알림을 받았을 때 수행할 작업
                guard let notiUserID = notification.object as? String else { return }
                
                Task {
                    await handlePostitNotification(notiUserID: notiUserID)
                }
            }
        }
    }
    
    // 팔로잉, 서퍼지정 알림
    @MainActor
    private func handleProfileNotification(notiUserID: String) async {
        self.pushUser = await UpdateUserData.shared.getOthersProfileDatas(id: notiUserID)
        self.showPushProfile = true
    }
    
    // 댓글, 하트, 포토모지, 파도타기, 게시물 작성 알림
    @MainActor
    private func handlePostNotification(notiPostID: String) async {
        viewModel.showTab = 4
        self.pushPostID = notiPostID
        await notiVM.fetchNotificationPostData(postID: pushPostID)
        self.showPushPost = true
    }
    
    // 포스트잇 알림
    @MainActor
    private func handlePostitNotification(notiUserID: String) async {
        Task {
            try? await Task.sleep(nanoseconds: 1 * 500_000_000)
            viewModel.showTab = 4
            try? await Task.sleep(nanoseconds: 1 * 250_000_000)
            viewModel.isShowingMessageView = true
        }
    }
}

// MARK: FeedView에서 사용 될 Refresh 함수
extension ContentView: FeedRefreshDelegate {
    func feedRefresh() async {
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        if viewModel.selectedFilter == FeedFilter.following {
            guard !userNameID.isEmpty else {
                await feedVM.getPopularUser()
                feedVM.stopFollowingListeners()
                profileVM.stopAllPostListeners()
                feedVM.followingPosts.removeAll()
                return
            }
            await profileVM.fetchBlockUsers()
            await followVM.initializeFollowFetch(id: userNameID)
            feedVM.followFetchLoading = true
            feedVM.stopFollowingListeners()
            profileVM.stopAllPostListeners()
            await feedVM.fetchFollowingPosts()
            await profileVM.fetchPostID(user: viewModel.currentUser!)
            await notiVM.fetchNotifications()
            feedVM.followFetchLoading = false
        } else {
            Task{
                await profileVM.fetchBlockUsers()
                feedVM.stopTodayListeners()
                await feedVM.fetchTodayPadoPosts()
                guard !userNameID.isEmpty else { return }
                await followVM.initializeFollowFetch(id: userNameID)
                await profileVM.fetchPostID(user: viewModel.currentUser!)
                await notiVM.fetchNotifications()
            }
        }
    }
}
