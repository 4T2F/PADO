//
//  Settings.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State var width = UIScreen.main.bounds.width
    @EnvironmentObject var viewModel: AuthenticationViewModel

    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    VStack {
                        ZStack {
                            Text("설정")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20))
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    VStack {
                        NavigationLink {
                            EditProfileView(currentUser: viewModel.currentUser!)
                                .navigationBarBackButtonHidden()
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 90)
                                .foregroundStyle(.white)
                                .opacity(0.07)
                                .overlay {
                                    HStack {
                                        Circle()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(30)
                                            .foregroundStyle(Color(red: 152/255, green: 163/255, blue: 16/255))
                                            .overlay {
                                                Text(viewModel.currentUser!.name.prefix(1).uppercased())
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 25))
                                            }
                                        
                                        VStack(alignment: .leading) {
                                            Text(viewModel.currentUser!.name)
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 18))
                                            
                                            Text(viewModel.currentUser!.username ?? viewModel.currentUser!.name.lowercased())
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 14))
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.gray)
                                    }
                                    .padding(.horizontal, 18)
                                }
                        }
                        
                        VStack(spacing: 6) {
                            HStack {
                                Text("기능")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                                
                                Spacer()
                            }
                            
                            NavigationLink {
                                MemoriesView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: width * 0.9, height: 45)
                                        .foregroundStyle(.white)
                                        .opacity(0.07)
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundStyle(.white)
                                        
                                        Text("추억")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 14))
                                    }
                                    .padding(.horizontal, width * 0.1)
                                    .frame(height: 30)
                                }
                            }
                            
                        }
                        .padding(.top, 12)
                        
                        VStack(spacing: 6) {
                            HStack {
                                Text("설정")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                                
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: width * 0.9, height: 145)
                                    .foregroundStyle(.white)
                                    .opacity(0.07)
                                
                                VStack {
                                    NavigationLink {
                                        NotificationsView()
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.pencil")
                                                .foregroundStyle(.white)
                                            
                                            Text("알림")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                    
                                    Rectangle()
                                        .frame(width: width * 0.9, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                    
                                    NavigationLink {
                                        TimeZoneView()
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "globe.asia.australia.fill")
                                                .foregroundStyle(.white)
                                            
                                            Text("시간대: 동아시아")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                    
                                    Rectangle()
                                        .frame(width: width * 0.9, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                    
                                    NavigationLink {
                                        OtherView()
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "hammer.circle")
                                                .foregroundStyle(.white)
                                            
                                            Text("다른 설정들")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                }
                            }
                        }
                        .padding(.top, 12)
                        
                        VStack(spacing: 6) {
                            HStack {
                                Text("정보")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                                
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: width * 0.9, height: 190)
                                    .foregroundStyle(.white)
                                    .opacity(0.07)
                                
                                VStack {
                                    NavigationLink {
                                        
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundStyle(.white)
                                            
                                            Text("PADO 공유하기.")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                    
                                    Rectangle()
                                        .frame(width: width * 0.9, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        HStack {
                                            Image(systemName: "star")
                                                .foregroundStyle(.white)
                                            
                                            Text("PADO 평가하기.")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                    
                                    Rectangle()
                                        .frame(width: width * 0.9, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                    
                                    NavigationLink {
                                        HelpView()
                                            .navigationBarBackButtonHidden()
                                    } label: {
                                        HStack {
                                            Image(systemName: "lifepreserver")
                                                .foregroundStyle(.white)
                                            
                                            Text("도움 받기")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                    
                                    Rectangle()
                                        .frame(width: width * 0.9, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                    
                                    NavigationLink {
                                        
                                    } label: {
                                        HStack {
                                            Image(systemName: "info.circle")
                                                .foregroundStyle(.white)
                                            
                                            Text("정보")
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .padding(.horizontal, width * 0.1)
                                        .frame(height: 30)
                                    }
                                }
                            }
                        }
                        .padding(.top, 12)
                        
                        // LOGOUT
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: width * 0.9, height: 40)
                                .foregroundStyle(.white)
                                .opacity(0.07)
                            
                            HStack {
                                Spacer()
                                
                                Button {
                                    viewModel.signOut()
                                    viewModel.navigationTag = ""
                                    viewModel.phoneNumber = ""
                                    viewModel.otpText = ""
                                } label: {
                                    Text("로그아웃")
                                        .foregroundStyle(.red)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, width * 0.1)
                            .frame(height: 30)
                        }
                        .padding(.top, 12)
                        
                        Text("Version 1.21.2")
                            .foregroundStyle(.gray)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                    }
                    .padding(.top, 24)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    SettingsView()
//}
