//
//  ReMyFeedView.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct ReMyFeedView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.modalBlackButton.ignoresSafeArea()
                VStack {
                    VStack {
                        HStack {
                            Text("PADO")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 22))
                            
                            Spacer()
                            
                            VStack {
                                NavigationLink(destination: SettingView()) {
                                    Text("...")
                                        .font(.system(size: 34))
                                        .foregroundStyle(.white)
                                }
                                
                                
                                Text("")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            ProfileCell()
                            
                            MyFeedContentView()
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ReMyFeedView()
}
