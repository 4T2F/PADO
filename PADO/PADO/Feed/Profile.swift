//
//  Profile.swift
//  BeReal
//
//  Created by 강치우 on 12/31/23.
//

import SwiftUI

struct Profile: View {
    
    @Binding var mainMenu: String
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Circle()
                                .frame(width: 130, height: 130)
                                .cornerRadius(75)
                                .foregroundStyle(Color(red: 152/255, green: 163/255, blue: 16/255))
                                .overlay {
                                    Text(viewModel.currentUser!.name.prefix(1).uppercased())
                                        .foregroundStyle(.white)
                                        .font(.system(size: 55))
                                }
                            
                            Text(viewModel.currentUser!.name)
                                .foregroundStyle(.white)
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                            
                            Text(viewModel.currentUser!.username ?? viewModel.currentUser!.name.lowercased())
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Text("회원님의 추억들")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "lock.fill")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 10))
                                    
                                    Text("당신에게만 보입니다")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 10))
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.top, 4)
                            
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(.white)
                                        .opacity(0.07)
                                        .frame(height: 230)
                                    
                                    VStack {
                                        HStack {
                                            Text("지난 14 일들")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                                .padding(.top, -10)
                                            
                                            Spacer()
                                        }
                                        .padding(.leading)
                                        .padding(.vertical)
                                        
                                        VStack {
                                            HStack(spacing: 4) {
                                                ForEach(1..<8) { x in
                                                    MemoryView(day: x)
                                                }
                                            }
                                            
                                            HStack(spacing: 4) {
                                                ForEach(1..<8) { x in
                                                    MemoryView(day: x + 7)
                                                }
                                            }
                                            .padding(.top, -4)
                                        }
                                        .padding(.top, -10)
                                        
                                        Text("모든 추억 보기")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 13))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(.gray, lineWidth: 2)
                                                    .frame(width: 110, height: 35)
                                                    .opacity(0.5)
                                            }
                                            .padding(.top, 11)
                                    }
                                    .padding(.top, -15)
                                }
                            }
                            
                            Text("🔗 pa.do/kangciu")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                        .padding(.top, 35)
                    }
                    
                    VStack {
                        HStack {
                            Button {
                                withAnimation {
                                    self.mainMenu = "feed"
                                }
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Text("프로필")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            NavigationLink {
                                SettingsView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                ThreeDots(size: 4, color: .white)
                            }

                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    Profile(mainMenu: .constant("profile"))
}
