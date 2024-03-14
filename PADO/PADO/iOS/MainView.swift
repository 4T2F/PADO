//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import Firebase
import FirebaseFirestore

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            ZStack {
                ContentView()
                if viewModel.showLaunchScreen {
                    LaunchSTA()
                        .onAppear {
                            Task {
                                viewModel.nameID = userNameID
                                await viewModel.initializeUser()
                            }
                        }
                }
            }
        }
    }
}
