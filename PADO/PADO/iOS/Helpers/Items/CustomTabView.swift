//
//  CustomTabView.swift
//  PADO
//
//  Created by 최동호 on 2/22/24.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width,
                       height: 49)
                .foregroundStyle(Color.black)
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Button {
                        if viewModel.showTab == 0 {
                            viewModel.scrollToTop.toggle()
                        }
                        viewModel.showTab = 0
                        viewModel.resetNavigation.toggle()
                    } label: {
                        VStack(spacing: 6) {
                            Image(viewModel.showTab == 0 ? "home_light" : "home_gray")
                                .padding(.top, 6)
                            
                            Text("홈")
                                .font(.system(size: 12))
                                .foregroundStyle(viewModel.showTab == 0 ? .white : .gray)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        viewModel.showTab = 1
                    } label: {
                        VStack(spacing: 6) {
                            Image(viewModel.showTab == 1 ? "search_light" : "search_gray")
                                .padding(.top, 6)
                            
                            Text("검색")
                                .font(.system(size: 12))
                                .foregroundStyle(viewModel.showTab == 1 ? .white : .gray)
                            
                            
                            Spacer()
                        }
                        
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        viewModel.showTab = 2
                    } label: {
                        VStack {
                            Image(viewModel.showTab == 2 ? "tab_added" : "tab_add")
                                .padding(.top, 6)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        viewModel.showTab = 3
                    } label: {
                        VStack(spacing: 6) {
                            Image(viewModel.showTab == 3 ? "today_light" : "today_gray")
                                .padding(.top, 6)
                            
                            Text("파도타기")
                                .font(.system(size: 12))
                                .foregroundStyle(viewModel.showTab == 3 ? .white : .gray)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        viewModel.showTab = 4
                    } label: {
                        VStack(spacing: 6) {
                            Image(viewModel.showTab == 4 ? "profile_light" : "profile_gray")
                                .padding(.top, 6)
                            
                            Text("프로필")
                                .font(.system(size: 12))
                                .foregroundStyle(viewModel.showTab == 4 ? .white : .gray)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                }
            }
        }
        .frame(height: 49)
    }
}
