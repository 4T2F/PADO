//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        Group {
            ZStack {
                HomeView()
                if viewModel.showLaunchScreen {
                    LaunchSTA()
                        .task {
                            await viewModel.initializeUser()
                        }
                }
            }
        }
    }
}
