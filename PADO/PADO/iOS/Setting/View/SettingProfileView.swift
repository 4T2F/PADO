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
    @State var age: String = ""
    @State var bio: String = ""
    @State var instaAddress: String = ""
    @State var tiktokAddress: String = ""
    
    @Environment (\.dismiss) var dismiss
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
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
                                    Text("이름")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("이름", text: $username)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정, 나이
                            HStack {
                                HStack {
                                    Text("나이")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("나이", text: $age)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정, 소개
                            HStack(alignment: .top) {
                                HStack {
                                    Text("소개")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .padding(.leading, -4)
                                .padding(.top, 4)
                                .frame(width: width * 0.2)
                                
                                TextEditor(text: $bio)
                                    .foregroundStyle(.white)
                                    .scrollContentBackground(.hidden) // iOS 16 버전 이상부터 지원함 15 버전 일시 if #available(iOS 16, *)
                                    .frame(height: 100)
                                    .padding(.leading, width * 0.05)
                                    .overlay {
                                        VStack {
                                            HStack {
                                                if bio == "" {
                                                    Text("소개")
                                                        .foregroundStyle(.gray)
                                                        .font(.system(size: 16))
                                                        .zIndex(1)
                                                        .padding(.top, 8)
                                                        .padding(.leading, 24)
                                                }
                                                
                                                Spacer()
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding(.top, -4)
                                    .frame(width: width * 0.63)
                                
                            }
                            
                            SettingProfileDivider()
                            
                            // MARK: - 프로필수정, 인스타그램 주소
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
