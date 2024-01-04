//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if viewModel.currentUser == nil {
                MainAuthenticationView()
            } else {
                if let user = viewModel.currentUser {
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
