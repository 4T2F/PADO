//
//  LeftMenu.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct LeftMenu: View {
    
    @State var width = UIScreen.main.bounds.width
    @State var menu = "suggestions"
    
    @Binding var mainMenu: String
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                LeftMenuTopView(mainMenu: $mainMenu)
                
                if menu == "suggestions" {
                    Suggestions()
                } else if menu == "friends" {
                    FriendsView()
                } else if menu == "requests" {
                    RequestsView()
                }
                
                VStack {
                    Spacer()
                    ZStack {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 22)
                                    .frame(width: width * 0.48, height: 40)
                                    .foregroundStyle(Color(red: 20/255, green: 20/255, blue: 20/255))
                                
                                HStack(spacing: 4) {
                                    Capsule()
                                        .frame(width: 50, height: 28)
                                        .foregroundStyle(Color(red: 46/255, green: 46/255, blue: 48/255))
                                        .opacity(menu == "suggestions" ? 1: 0)
                                        .overlay {
                                            Text("추천")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                        }
                                        .onTapGesture {
                                            self.menu = "suggestions"
                                        }
                                    
                                    Capsule()
                                        .frame(width: 65, height: 28)
                                        .foregroundStyle(Color(red: 46/255, green: 46/255, blue: 48/255))
                                        .opacity(menu == "friends" ? 1: 0)
                                        .overlay {
                                            Text("친구들")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                        }
                                        .onTapGesture {
                                            self.menu = "friends"
                                        }
                                    
                                    Capsule()
                                        .frame(width: 50, height: 28)
                                        .foregroundStyle(Color(red: 46/255, green: 46/255, blue: 48/255))
                                        .opacity(menu == "requests" ? 1: 0)
                                        .overlay {
                                            Text("요청")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                        }
                                        .onTapGesture {
                                            self.menu = "requests"
                                        }
                                }
                            }
                        }
                        .zIndex(1)
                        
                        LinearGradient(colors: [.black, .white.opacity(0)], startPoint: .bottom, endPoint: .top)
                            .ignoresSafeArea()
                            .frame(height: 60)
                            .opacity(0.9)
                    }
                }
            }
        }
    }
}

#Preview {
    LeftMenu(mainMenu: .constant("left"))
}
