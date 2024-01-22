//
//  MainView.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
            if viewModel.currentUser == nil {
                StartView(viewModel: viewModel)
            } else {
                ContentView()
            }
        }
    }
}

#Preview {
    MainView()
}
