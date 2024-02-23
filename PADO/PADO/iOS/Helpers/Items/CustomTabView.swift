//
//  CustomTabView.swift
//  PADO
//
//  Created by 최동호 on 2/22/24.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var isShowingStartView: Bool = false
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
                        resetNavigation.toggle()
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
                        if !userNameID.isEmpty {
                            viewModel.showTab = 2
                        } else {
                            isShowingStartView = true
                        }
                    } label: {
                        VStack {
                            Image(viewModel.showTab == 2 ? "tab_added" : "tab_add")
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    .sheet(isPresented: $isShowingStartView, content: {
                        StartView()
                            .presentationDragIndicator(.visible)
                    })
                    
                    Button {
                        if !userNameID.isEmpty {
                            viewModel.showTab = 3
                        } else {
                            isShowingStartView = true
                        }
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
                    .sheet(isPresented: $isShowingStartView, content: {
                        StartView()
                            .presentationDragIndicator(.visible)
                    })
                    
                    Button {
                        viewModel.showTab = 4
                        if userNameID.isEmpty {
                            isShowingStartView = true
                        }
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
                    .sheet(isPresented: $isShowingStartView, content: {
                        StartView()
                            .presentationDragIndicator(.visible)
                    })
                }
            }
        }
        .frame(height: 49)
    }
}
