//
//  CustomTabView.swift
//  PADO
//
//  Created by 최동호 on 2/22/24.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
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
                        if !enteredNavigation && viewModel.showTab == 0 {
                            viewModel.scrollToTop.toggle()
                        }
                        viewModel.showTab = 0
                        resetNavigation.toggle()
                    } label: {
                        VStack(spacing: 6) {
                            Image(viewModel.showTab == 0 ? "home_white" : "home")
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    
                    Button {
                        viewModel.showTab = 1
                    } label: {
                        VStack(spacing: 6) {
                            Image(viewModel.showTab == 1 ? "search_white" : "search")
                                .padding(.top, 9)
                            
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
                            Image(viewModel.showTab == 2 ? "tab_white" : "tab")
                                .padding(.top, 9.5)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    .sheet(isPresented: $isShowingStartView, content: {
                        StartView(isShowStartView: $isShowingStartView)
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
                            Image(viewModel.showTab == 3 ? "surf_white" : "surf")
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    .sheet(isPresented: $isShowingStartView, content: {
                        StartView(isShowStartView: $isShowingStartView)                           
                            .presentationDragIndicator(.visible)
                    })
                    
                    Button {
                        viewModel.showTab = 4
                        if userNameID.isEmpty {
                            isShowingStartView = true
                        }
                    } label: {
                        VStack(spacing: 6) {
                            if let user = viewModel.currentUser {
                                CircularImageView(size: .tab, user: user)
                                    .padding(.top, 10)
                                    .overlay {
                                        Circle()
                                            .stroke(viewModel.showTab == 4 ? .white : .clear)
                                            .frame(width: 30)
                                            .foregroundStyle(.clear)
                                            .padding(.top, 9)
                                    }
                            } else {
                                Image("defaultProfile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .padding(.top, 10)
                                    .foregroundStyle(Color(.systemGray4))
                                    .overlay {
                                        Circle()
                                            .stroke(viewModel.showTab == 4 ? .white : .clear)
                                            .frame(width: 30)
                                            .foregroundStyle(.clear)
                                            .padding(.top, 9)
                                    }
                            }
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width / 5)
                    .sheet(isPresented: $isShowingStartView, content: {
                        StartView(isShowStartView: $isShowingStartView)
                            .presentationDragIndicator(.visible)
                    })
                }
            }
        }
        .frame(height: 49)
    }
}
