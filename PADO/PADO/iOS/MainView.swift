//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import Firebase
import FirebaseFirestore
import SwiftUI

enum ViewStatus {
    case launchScreen, startView, contentView
}

struct MainView: View {
    @State private var viewStatus = ViewStatus.launchScreen
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            switch viewStatus {
            case .launchScreen:
                LaunchSTA()
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                            if Auth.auth().currentUser?.uid == nil {
                                viewStatus = .startView
                            } else {
                                if userNameID.isEmpty {
                                    await viewModel.fetchNameID()
                                }
                                await viewModel.initializeUser()
                                viewStatus = .contentView
                            }
                        }
                    }
            case .startView:
                StartView()
            case .contentView:
                ContentView()
            }
        }
    }
}

// #Preview {
//    MainView()
// }
