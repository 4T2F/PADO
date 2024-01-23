//
//  SettingProfileView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI
import PhotosUI

struct SettingProfileView: View {
    
    @State var width = UIScreen.main.bounds.width
    
    let user: User
    
    @State var username: String = ""
    @State var instaAddress: String = ""
    @State var tiktokAddress: String = ""
    
    @Environment (\.dismiss) var dismiss
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // MARK: - 프로필수정, 탑셀
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                            
                            Spacer()
                            
                            Button {
                                Task {
                                    try await viewModel.updateUserData()
                                    dismiss()
                                }
                            } label: {
                                Text("저장")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 18))
                            }
                        }
                        .padding(.horizontal, width * 0.05)
                        
                        Text("프로필 수정")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        
                        SettingProfileDivider()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack {
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = viewModel.profileImageUrl {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 129, height: 129)
                                    .clipShape(Circle())
                            } else {
                                CircularImageView(user: user, size: .xxLarge)
                            }
                        }
                        // MARK: - 프로필수정, 이름
                        VStack {
                            SettingProfileDivider()
                            
                            HStack {
                                HStack {
                                    Text("닉네임")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("닉네임", text: $username)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정
                            HStack {
                                HStack {
                                    Text("Instagram")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("계정명", text: $instaAddress)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정, 틱톡주소
                            HStack {
                                HStack {
                                    Text("Tiktok")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("계정명", text: $tiktokAddress)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            
                            SettingProfileDivider()
                            
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, width * 0.05)
                        .padding(.top, 24)
                        
                        Spacer()
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.08)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    SettingProfileView()
//}
