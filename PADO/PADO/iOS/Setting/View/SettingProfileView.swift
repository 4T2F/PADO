//
//  SettingProfileView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import PhotosUI
import SwiftUI

struct SettingProfileView: View {
    // MARK: - PROPERTY
    @State var width = UIScreen.main.bounds.width
    @State private var isActive: Bool = false
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment (\.dismiss) var dismiss
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    // MARK: - 프로필수정, 탑셀
                    VStack {
                        ZStack {
                            HStack {
                                Button {
                                    dismiss()
                                    authVM.imagePick = false
                                    authVM.userSelectImage = nil
                                } label: {
                                    Text("취소")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                                
                                Text("프로필 수정")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Button {
                                    // 버튼이 활성화된 경우 실행할 로직
                                    if isActive {
                                        Task {
                                            await authVM.profileSaveData()
                                            authVM.imagePick.toggle()
                                            authVM.userSelectImage = nil
                                            
                                            dismiss()
                                        }
                                    }
                                    // 비활성화 상태일 때는 아무 작업도 수행하지 않음
                                } label: {
                                    Text("저장")
                                        .foregroundStyle(isActive ? .white : .gray) // 활성화 상태에 따라 텍스트 색상 변경
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                }
                                .disabled(!isActive) // 버튼 비활성화 여부 결정
                                .onChange(of: authVM.changedValue) { newValue, oldValue in
                                    isActive = !newValue // viewModel의 changedValue에 따라 isActive 상태 업데이트
                                }
                            }
                            .padding(.top, 5)
                            .padding(.horizontal, width * 0.05)
                        }
                        
                        HStack {
                            SettingProfileDivider()
                        }
                        
                        Spacer()
                    }
                    
                    VStack {
                        VStack {
                            PhotosPicker(selection: $authVM.selectedItem) {
                                if let image = authVM.userSelectImage {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 129, height: 129)
                                        .clipShape(Circle())
                                        .onAppear() {
                                            authVM.imagePick.toggle()
                                        }
                                } else {
                                    CircularImageView(size: .xxxLarge)
                                }
                            }
                            .onChange(of: authVM.selectedItem) { _, _  in
                                authVM.showingEditProfile.toggle()
                            }
                            .onChange(of: authVM.imagePick) { _, _  in
                                authVM.checkForChanges()
                            }
                            // MARK: - 프로필수정, 이름
                            VStack {
                                SettingProfileDivider()
                                
                                HStack {
                                    HStack {
                                        Text("닉네임")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                        
                                        Spacer()
                                    }
                                    .frame(width: width * 0.22)
                                    
                                    HStack {
                                        if let originUsername = authVM.currentUser?.username, !originUsername.isEmpty {
                                            TextField(originUsername, text: $authVM.username)
                                                .font(.system(size: 16))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: authVM.username) { _, _ in
                                                    authVM.checkForChanges()
                                                }
                                        } else {
                                            TextField("닉네임", text: $authVM.username)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: authVM.username) { _, _  in
                                                    authVM.checkForChanges()
                                                }
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(width: width * 0.63)
                                }
                                .padding(.vertical, 4)
                                
                                SettingProfileDivider()
                                
                                // MARK: - Insta
                                HStack {
                                    HStack {
                                        Text("Instagram")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                        
                                        Spacer()
                                    }
                                    .frame(width: width * 0.22)
                                    
                                    HStack {
                                        if let insta = authVM.currentUser?.instaAddress, !insta.isEmpty {
                                            TextField(insta, text: $authVM.instaAddress)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: authVM.instaAddress) { _, _  in
                                                    authVM.checkForChanges()
                                                }
                                            
                                        } else {
                                            TextField("계정명", text: $authVM.instaAddress)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: authVM.instaAddress) { _, _  in
                                                    authVM.checkForChanges()
                                                }
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                    .frame(width: width * 0.63)
                                }
                                
                                SettingProfileDivider()
                                
                                // MARK: - 프로필수정, 틱톡주소
                                HStack {
                                    HStack {
                                        Text("tiktok")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                        
                                        Spacer()
                                    }
                                    .frame(width: width * 0.22)
                                    
                                    HStack {
                                        if let tiktok = authVM.currentUser?.tiktokAddress, !tiktok.isEmpty {
                                            TextField(tiktok, text: $authVM.tiktokAddress)
                                                .font(.system(size: 16))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: authVM.tiktokAddress) { _, _  in
                                                    authVM.checkForChanges()
                                                }
                                        } else {
                                            TextField("계정명", text: $authVM.tiktokAddress)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: authVM.tiktokAddress) { _, _  in
                                                    authVM.checkForChanges()
                                                }
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                    .frame(width: width * 0.63)
                                }
                                
                                SettingProfileDivider()
                                
                            }
                            .padding(.horizontal, width * 0.05)
                            .padding(.top, 24)
                            
                            Spacer()
                        }
                        .padding(.top, UIScreen.main.bounds.height * 0.08)
                    }
                }
            }
            .padding(.top, 10)
            .onAppear {
                authVM.fetchUserProfile()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $authVM.showingEditProfile) {
                SettingProfileEditView { croppedImage, status in
                    if let croppedImage {
                        authVM.uiImage = croppedImage
                    }
                }
            }
        }
    }
}
