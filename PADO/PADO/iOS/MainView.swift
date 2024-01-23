//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI

struct MainView: View {
    @State private var showLaunchScreen = true
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if showLaunchScreen {
                LunchSTA()
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                            withAnimation {
                                if viewModel.userID == "" || !viewModel.isLoading {
                                    showLaunchScreen = false
                                }
                            }
                        }
                    }
            } else if viewModel.currentUser == nil {
                StartView()
            } else {
                ContentView()
            }
        }
    }
}

//#Preview {
//    MainView()
//}
