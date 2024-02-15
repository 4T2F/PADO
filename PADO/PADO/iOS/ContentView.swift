//
//  ContentView.swift
//  PADO
//
//  Created by 최동호 on 1/2/24.
//

import SwiftUI

struct ContentView: View {
    @State var width = UIScreen.main.bounds.width
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @StateObject var surfingVM = SurfingViewModel()
    @StateObject var feedVM = FeedViewModel()
    @StateObject var followVM = FollowViewModel()
    @StateObject var searchVM = SearchViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var notiVM = NotificationViewModel()
    @StateObject var postitVM = PostitViewModel()
    @StateObject var padorideVM = PadoRideViewModel()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $viewModel.showTab) {
            FeedView(feedVM: feedVM,
                     surfingVM: surfingVM,
                     profileVM: profileVM,
                     followVM: followVM,
                     notiVM: notiVM)
            .tabItem {
                Image(viewModel.showTab == 0 ? "home_light" : "home_gray")
                
                Text("홈")
            }
            .onAppear { viewModel.showTab = 0 }
            .tag(0)
            
            MainSearchView(searchVM: searchVM,
                           profileVM: profileVM,
                           followVM: followVM)
            .tabItem {
                Image(viewModel.showTab == 1 ? "search_light" : "search_gray")
                
                Text("검색")
            }
            .onAppear { viewModel.showTab = 1 }
            .tag(1)
            
            if let user = viewModel.currentUser {
                SurfingView(surfingVM: surfingVM,
                            feedVM: feedVM, profileVM:
                                profileVM, followVM:
                                followVM)
                .tabItem {
                    Text("")
                    
                    Image(viewModel.showTab == 2 ? "tab_added" : "tab_add")
                }
                .onAppear { viewModel.showTab = 2 }
                .tag(2)
                
                PadoRideView(followVM: followVM, padorideVM: padorideVM)
                    .tabItem {
                        Image(viewModel.showTab == 3 ? "today_light" : "today_gray")
                        
                        Text("파도타기")
                    }
                    .onAppear { viewModel.showTab = 3 }
                    .tag(3)
                
                
                ProfileView(profileVM: profileVM,
                            followVM: followVM,
                            feedVM: feedVM,
                            postitVM: postitVM,
                            user: user)
                .tabItem {
                    Image(viewModel.showTab == 4 ? "profile_light" : "profile_gray")
                    
                    Text("프로필")
                }
                .onAppear { viewModel.showTab = 4 }
                .tag(4)
            } else {
                LoginAlert()
                    .tabItem {
                        Text("")
                        
                        Image(viewModel.showTab == 2 ? "tab_added" : "tab_add")
                    }
                    .onAppear {viewModel.showTab = 2 }
                    .tag(2)
                    
                LoginAlert()
                    .tabItem {
                        Image(viewModel.showTab == 3 ? "today_light" : "today_gray")
                        
                        Text("파도타기")
                    }
                    .onAppear { viewModel.showTab = 3 }
                    .tag(3)
                
                LoginAlert()
                    .tabItem {
                        Image(viewModel.showTab == 4 ? "profile_light" : "profile_gray")
                        
                        Text("프로필")
                    }
                    .onAppear { viewModel.showTab = 4 }
                    .tag(4)
            }
        }
        .tint(.white)
        .onAppear {
            fetchData()
           
        }
        .onChange(of: viewModel.needsDataFetch) { _, newValue in
            feedVM.findFollowingUsers()
            fetchData()
        }
    }
    
    func fetchData() {
        Task {
            if !userNameID.isEmpty {
                followVM.initializeFollowFetch(id: userNameID)
                viewModel.selectedFilter = .following
                viewModel.showTab = 0
                await profileVM.fetchPostID(id: userNameID)
                await notiVM.fetchNotifications()
                await postitVM.getMessageDocument(ownerID: userNameID)
            }
        }
    }
}
