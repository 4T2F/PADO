//
//  SettingProfileView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingProfileView: View {
    
    @State var width = UIScreen.main.bounds.width

    @State var username: String = ""
    @State var age: String = ""
    @State var bio: String = ""
    @State var instaAddress: String = ""
    @State var tiktokAddress: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
                // MARK: - 프로필수정, 탑셀
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                //TODO: - 취소버튼 동작 구현필요
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                            
                            Spacer()
                            
                            Button {
                                //TODO: - 저장버튼 동작 구현필요
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
                        
                        SettingProfileDevider()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack {
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                Circle()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(60)
                                    .foregroundStyle(Color(red: 152/255, green: 163/255, blue: 16/255))
                                    .overlay {
                                        Text("\(username)")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 55))
                                    }
                                
                                ZStack {
                                    ZStack {
                                        Circle()
                                            .frame(width: 34, height: 34)
                                            .foregroundStyle(.black)
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.white)
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.black)
                                            .opacity(0.1)
                                    }
                                    Button {
                                        //TODO: - 카메라/포토피커 동작 구현필요
                                    } label: {
                                        Image(systemName: "camera.fill")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 16))
                                            .shadow(color: .white, radius: 1, x: 1, y: 1)
                                    }
                                }
                            }
                        }
                        // MARK: - 프로필수정, 이름
                        VStack {
                            SettingProfileDevider()
                            
                            HStack {
                                HStack {
                                    Text("이름")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("", text: $username)
                                        .font(.system(size: 16))
                                        .placeholder(when: username.isEmpty) {
                                            Text("이름")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDevider()
                            
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
                                    TextField("", text: $age)
                                        .font(.system(size: 16))
                                        .placeholder(when: age.isEmpty) {
                                            Text("나이")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDevider()
                            
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
                            
                            SettingProfileDevider()
                            
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
                                    TextField("", text: $instaAddress)
                                        .font(.system(size: 16))
                                        .placeholder(when: instaAddress.isEmpty) {
                                            Text("계정명")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            SettingProfileDevider()
                            
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
                                    TextField("", text: $tiktokAddress)
                                        .font(.system(size: 16))
                                        .placeholder(when: tiktokAddress.isEmpty) {
                                            Text("계정명")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            
                            SettingProfileDevider()
                            
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
    }
}

struct SettingProfileDevider: View {
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.7)
            .foregroundStyle(.gray)
            .opacity(0.3)
    }
}

#Preview {
    SettingProfileView()
}
