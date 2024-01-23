//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI

struct MainView: View {
    @State private var showLaunchScreen = true
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
            if showLaunchScreen {
                LunchSTA()
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                            withAnimation {
                                if !viewModel.isLoading {
                                    showLaunchScreen = false
                                }
                            }
                        }
                    }
            } else if viewModel.startUser == nil {
                StartView(viewModel: viewModel)
            } else {
                ContentView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
            }
        }
    }
}

//#Preview {
//    MainView()
//}
