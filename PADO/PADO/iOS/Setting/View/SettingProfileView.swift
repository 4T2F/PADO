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
    @EnvironmentObject var viewModel: AuthenticationViewModel
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
                                    viewModel.imagePick = false
                                    viewModel.userSelectImage = nil
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
                                            await viewModel.profileSaveData()
                                            viewModel.imagePick.toggle()
                                            viewModel.userSelectImage = nil
                                            
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
                                .onChange(of: viewModel.changedValue) { newValue, oldValue in
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
//                            PhotosPicker(selection: $viewModel.selectedItem) {
//                                if let image = viewModel.userSelectImage {
//                                    image
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 129, height: 129)
//                                        .clipShape(Circle())
//                                        .onAppear {
//                                            viewModel.imagePick.toggle()
//                                        }
//                                } else {
//                                    if let user = viewModel.currentUser {
//                                        CircularImageView(size: .xxxLarge, user: user)
//                                    }
//                                }
//                            }
                            
                            // 변경사항에 맞춰 이미지 보여주는 기능 만들기
                            viewModel.backSelectImage?
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                            
                            if let user = viewModel.currentUser {
                                CircularImageView(size: .xxxLarge, user: user)
                                    .onChange(of: viewModel.selectedItem) { _, _  in
                                        viewModel.showingEditProfile = true
                                    }
                                    .onChange(of: viewModel.selectedBackgroundItem) { _, _  in
                                        viewModel.showwingEditBackProfile = true
                                    }
                                    .onChange(of: viewModel.imagePick) { _, _  in
                                        viewModel.checkForChanges()
                                    }
                                    .overlay {
                                        Button {
                                            viewModel.showProfileModal = true
                                        } label: {
                                            Image(systemName: "plus.circle")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundStyle(.white)
                                        }
                                        .offset(x: 47, y: 47)
                                    }
                                    .sheet(isPresented: $viewModel.showProfileModal) {
                                        SettingProfileModal()
                                            .presentationDetents([.fraction(0.3)])
                                    }
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
                                        if let originUsername = viewModel.currentUser?.username, !originUsername.isEmpty {
                                            TextField(originUsername, text: $viewModel.username)
                                                .font(.system(size: 16))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: viewModel.username) { _, _ in
                                                    viewModel.checkForChanges()
                                                }
                                        } else {
                                            TextField("닉네임", text: $viewModel.username)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: viewModel.username) { _, _  in
                                                    viewModel.checkForChanges()
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
                                        if let insta = viewModel.currentUser?.instaAddress, !insta.isEmpty {
                                            TextField(insta, text: $viewModel.instaAddress)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: viewModel.instaAddress) { _, _  in
                                                    viewModel.checkForChanges()
                                                }
                                            
                                        } else {
                                            TextField("계정명", text: $viewModel.instaAddress)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: viewModel.instaAddress) { _, _  in
                                                    viewModel.checkForChanges()
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
                                        if let tiktok = viewModel.currentUser?.tiktokAddress, !tiktok.isEmpty {
                                            TextField(tiktok, text: $viewModel.tiktokAddress)
                                                .font(.system(size: 16))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: viewModel.tiktokAddress) { _, _  in
                                                    viewModel.checkForChanges()
                                                }
                                        } else {
                                            TextField("계정명", text: $viewModel.tiktokAddress)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .padding(.leading, width * 0.05)
                                                .onChange(of: viewModel.tiktokAddress) { _, _  in
                                                    viewModel.checkForChanges()
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
                viewModel.fetchUserProfile()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.showingEditProfile) {
                SettingProfileEditView { croppedImage, status in
                    if let croppedImage {
                        viewModel.uiImage = croppedImage
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showwingEditBackProfile) {
                SettingBackProfileCropView { croppedImage, status in
                    if let croppedImage {
                        viewModel.backuiImage = croppedImage
                    }
                }
            }
        }
    }
}
