//
//  ContentView.swift
//  PADO
//
//  Created by 최동호 on 1/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var width = UIScreen.main.bounds.width
    @State var menu = "feed"
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.mainBackground
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                FeedView(isShowFollowButton: false, mainMenu: $menu)
                    .tabItem {
                        Image(selectedTab == 0 ? "Home_light" : "Home_gray")
                            .resizable()
                            .scaledToFit()
                            
                        Text("홈")
                    }
                    .onAppear { selectedTab = 0 }
                    .tag(0)
                
                MainSearchView()
                    .tabItem {
                        Image(selectedTab == 1 ? "Search_light" : "Search_gray")
                            .scaledToFit()
                        Text("검색")
                    }
                    .onAppear { selectedTab = 1 }
                    .tag(1)
                SurfingSearchView()
                    .tabItem {
                        Image(selectedTab == 2 ? "Add_square_light" : "Add_square_gray")
                            .scaledToFit()
                        Text("서핑")
                    }
                    .onAppear { selectedTab = 2 }
                    .tag(2)
                FeedView(isShowFollowButton: true, mainMenu: $menu)
                    .tabItem {
                        Image(selectedTab == 3 ? "Remove_light" : "Remove_gray")
                            .scaledToFit()
                        Text("오늘 파도")
                    }
                    .onAppear { selectedTab = 3 }
                    .tag(3)
                MyFeedView()
                    .tabItem {
                        Image(selectedTab == 4 ? "User_light" : "User_gray")
                            .scaledToFit()
                        Text("프로필")
                    }
                    .onAppear { selectedTab = 4 }
                    .tag(4)
                    .badge(10)
                
            }
            .tint(.white)
        }
    }
    // 터치 했을 때 진동 울리게 하는 haptics vibration 싱글톤
    class HapticManager {
        
        static let instance = HapticManager()
        
        // notification 함수
        func simpleSuccess() {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
        // impact 함수
        func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
}


#Preview {
    ContentView()
}

