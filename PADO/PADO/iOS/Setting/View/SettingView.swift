//
//  SettingView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
import SwiftUI

struct SettingView: View {
    @State var width = UIScreen.main.bounds.width
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    
    var name: String = "PADO"
    var nickName: String = "pado"
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    // MARK: - 설정뷰, 탑셀
                    VStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image("dismissArrow")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Text("설정")
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .padding(.trailing, 20)
                                
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        
                        
                        Spacer()
                    }
                    // MARK: - 설정뷰, 프로필설정
                    VStack {
                        // MARK: - 설정뷰, 설정
                        VStack(spacing: 6) {
                            HStack {
                                Text("설정")
                                    .settingMidCellModi()
                                
                                Spacer()
                            }
                            .padding(.top, 20)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: width * 0.9, height: 100)
                                    .foregroundStyle(.white)
                                    .opacity(0.04)
                                
                                VStack {
                                    HStack {
                                        NavigationLink(destination: SettingNotificationView()) {
                                            Image(systemName: "square.and.pencil")
                                                .foregroundStyle(.white)
                                            
                                            Text("알림")
                                                .settingFontModi()
                                            
                                            Spacer()
                                            
                                            Image(systemName: "arrow.forward")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.1)
                                    .frame(height: 30)
                                    
                                    SettingDivider()
                                    
                                    HStack {
                                        NavigationLink(destination: SettingOthersView()) {
                                            Image(systemName: "gearshape.2")
                                                .foregroundStyle(.white)
                                            
                                            Text("다른 설정들")
                                                .settingFontModi()
                                            Spacer()
                                            
                                            Image(systemName: "arrow.forward")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.1)
                                    .frame(height: 30)
                                }
                            }
                        }
                        
                        // MARK: - 설정뷰, 정보
                        VStack(spacing: 6) {
                            HStack {
                                Text("정보")
                                    .settingMidCellModi()
                                
                                Spacer()
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: width * 0.9, height: 145)
                                    .foregroundStyle(.white)
                                    .opacity(0.04)
                                
                                VStack {
                                    HStack {
                                        Image(systemName: "star")
                                            .foregroundStyle(.white)
                                        
                                        Text("PADO 평가하기")
                                            .settingFontModi()
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.forward")
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 14))
                                    }
                                    .padding(.horizontal, width * 0.1)
                                    .frame(height: 30)
                                    
                                    SettingDivider()
                                    
                                    HStack {
                                        NavigationLink(destination: SettingAskView()) {
                                            Image(systemName: "questionmark.circle")
                                                .foregroundStyle(.white)
                                            
                                            Text("문의하기")
                                                .settingFontModi()
                                            
                                            Spacer()
                                            
                                            Image(systemName: "arrow.forward")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.1)
                                    .frame(height: 30)
                                    
                                    SettingDivider()
                                    
                                    HStack {
                                        
                                        
                                        NavigationLink(destination: SettingInfoView()) {
                                            
                                            Image(systemName: "info.circle")
                                                .foregroundStyle(.white)
                                            
                                            Text("정보")
                                                .settingFontModi()
                                            
                                            Spacer()
                                            Image(systemName: "arrow.forward")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.1)
                                    .frame(height: 30)
                                }
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
                        // MARK: - 설정뷰, 로그아웃
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: width * 0.9, height: 40)
                                .foregroundStyle(.white)
                                .opacity(0.04)
                            
                            HStack {
                                Spacer()
                                
                                Button {
                                    viewModel.signOut()
                                } label: {
                                    Text("로그아웃")
                                        .foregroundStyle(.red)
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, width * 0.1)
                            .frame(height: 30)
                        }
                        .padding(.top, 12)
                        
                        Text("2024, PADO all rights reserved.Powered by 4T2F, Version 1.0.0")
                            .foregroundStyle(.gray)
                            .font(.system(size: 12))
                            .padding(.top)
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingView()
}
