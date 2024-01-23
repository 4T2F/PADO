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
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black
//    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                TabView(selection: $selectedTab) {
                    ReMainView()
                        .tabItem {
                            Image(selectedTab == 0 ? "tab_home" : "tab_home_gray")
                                
                            Text("홈")
                        }
                        .onAppear { selectedTab = 0 }
                        .tag(0)
                    
                    MainSearchView()
                        .tabItem {
                            Image(selectedTab == 1 ? "tab_search" : "tab_search_gray")
                            
                            Text("검색")
                        }
                        .onAppear { selectedTab = 1 }
                        .tag(1)
                    SurfingMakeView()
                        .tabItem {
                            Text("")
                            
                            Image("tab_add")
                        }
                        .onAppear { selectedTab = 2 }
                        .tag(2)
                    FeedView(isShowFollowButton: true, mainMenu: $menu)
                        .tabItem {
                            Image(selectedTab == 3 ? "tab_todaypado" : "tab_todaypado_gray")
                            
                            Text("오늘 파도")
                        }
                        .onAppear { selectedTab = 3 }
                        .tag(3)
                    MyFeedView()
                        .tabItem {
                            Image(selectedTab == 4 ? "tab_profile" : "tab_profile_gray")
                            
                            Text("프로필")
                        }
                        .onAppear { selectedTab = 4 }
                        .tag(4)
                        .badge(10)
                    
                }
                .tint(.white)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
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

