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
    @State var isActive: Bool = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment (\.dismiss) var dismiss
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ZStack {
                        VStack {
                            VStack {
                                if let image = viewModel.backSelectImage {
                                    image
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 1.0, height: 300)
                                        .scaledToFill()
                                        .overlay(
                                            LinearGradient(colors: [.clear,
                                                                    .main.opacity(0.1),
                                                                    .main.opacity(0.3),
                                                                    .main.opacity(0.5),
                                                                    .main.opacity(0.8),
                                                                    .main.opacity(1)], startPoint: .top, endPoint: .bottom)
                                        )
                                        .onAppear {
                                            viewModel.backimagePick = true
                                        }
                                        .overlay {
                                            if let image = viewModel.userSelectImage {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipShape(Circle())
                                                    .frame(width: 129, height: 129)
                                                    .onAppear {
                                                        viewModel.imagePick = true
                                                    }
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.white, lineWidth: 1.4)
                                                    )
                                                
                                            } else {
                                                if let user = viewModel.currentUser {
                                                    CircularImageView(size: .xxxxLarge, user: user)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.white, lineWidth: 1.4)
                                                        )
                                                }
                                            }
                                        }
                                        .onChange(of: viewModel.selectedItem) { _, _  in
                                            viewModel.showingEditProfile = true
                                        }
                                        .onChange(of: viewModel.selectedBackgroundItem) { _, _  in
                                            viewModel.showingEditBackProfile = true
                                        }
                                        .onChange(of: viewModel.imagePick) { _, _  in
                                            viewModel.checkForChanges()
                                        }
                                        .onChange(of: viewModel.backimagePick) { _, _  in
                                            viewModel.checkForChanges()
                                        }
                                        .overlay {
                                            Button {
                                                viewModel.showProfileModal = true
                                            } label: {
                                                Image("plusButton")
                                                    .resizable()
                                                    .frame(width: 35, height: 35)
                                            }
                                            .offset(x: 45, y: 45)
                                        }
                                        .sheet(isPresented: $viewModel.showProfileModal) {
                                            SettingProfileModal(isActive: $isActive)
                                                .presentationDetents([.fraction(0.4)])
                                                .presentationDragIndicator(.visible)
                                        }
                                } else {
                                    if let user = viewModel.currentUser {
                                        RectangleImageView(imageUrl: user.backProfileImageUrl)
                                            .overlay(
                                                LinearGradient(colors: [.clear,
                                                                        .main.opacity(0.1),
                                                                        .main.opacity(0.3),
                                                                        .main.opacity(0.5),
                                                                        .main.opacity(0.8),
                                                                        .main.opacity(1)], startPoint: .top, endPoint: .bottom)
                                            )
                                            .overlay {
                                                if let image = viewModel.userSelectImage {
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 129, height: 129)
                                                        .clipShape(Circle())
                                                        .onAppear {
                                                            viewModel.imagePick = true
                                                        }
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.white, lineWidth: 1.4)
                                                        )
                                                } else {
                                                    if let user = viewModel.currentUser {
                                                        CircularImageView(size: .xxxxLarge, user: user)
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(Color.white, lineWidth: 1.4)
                                                            )
                                                    }
                                                }
                                            }
                                            .onChange(of: viewModel.selectedItem) { _, _  in
                                                viewModel.showingEditProfile = true
                                            }
                                            .onChange(of: viewModel.selectedBackgroundItem) { _, _  in
                                                viewModel.showingEditBackProfile = true
                                            }
                                            .onChange(of: viewModel.imagePick) { _, _  in
                                                viewModel.checkForChanges()
                                            }
                                            .onChange(of: viewModel.backimagePick) { _, _  in
                                                viewModel.checkForChanges()
                                            }
                                            .overlay {
                                                Button {
                                                    viewModel.showProfileModal = true
                                                } label: {
                                                    Image("plusButton")
                                                        .resizable()
                                                        .frame(width: 35, height: 35)
                                                }
                                                .offset(x: 45, y: 45)
                                            }
                                            .sheet(isPresented: $viewModel.showProfileModal) {
                                                SettingProfileModal(isActive: $isActive)
                                                    .presentationDetents([.fraction(0.4)])
                                                    .presentationDragIndicator(.visible)
                                            }
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
                                                    .onChange(of: viewModel.username) { _, newValue in
                                                        if newValue.count > 8 {
                                                            viewModel.username = String(newValue.prefix(8))
                                                        }
                                                        viewModel.checkForChanges()
                                                    }
                                            } else {
                                                TextField("닉네임", text: $viewModel.username)
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(.white)
                                                    .padding(.leading, width * 0.05)
                                                    .onChange(of: viewModel.username) { _, newValue in
                                                        if newValue.count > 8 {
                                                            viewModel.username = String(newValue.prefix(8))
                                                        }
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
                                            Text("Tiktok")
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
//                            .padding(.top, UIScreen.main.bounds.height * 0.08)
                            .background(.main, ignoresSafeAreaEdges: .all)
                        }
                    }
                }
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("프로필 편집")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.showingEditProfile) {
                SettingProfileEditView { croppedImage, status in
                    if let croppedImage {
                        viewModel.uiImage = croppedImage
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showingEditBackProfile) {
                SettingBackProfileCropView { croppedImage, status in
                    if let croppedImage {
                        viewModel.backuiImage = croppedImage
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                        viewModel.imagePick = false
                        viewModel.backimagePick = false
                        viewModel.userSelectImage = nil
                        viewModel.backSelectImage = nil
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Text("뒤로")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 버튼이 활성화된 경우 실행할 로직
                        if isActive {
                            Task {
                                await viewModel.profileSaveData()
                                dismiss()
                                
                                viewModel.selectedItem = nil
                                viewModel.selectedBackgroundItem = nil
                                viewModel.userSelectImage = nil
                                viewModel.backSelectImage = nil
                            }
                        }
                        // 비활성화 상태일 때는 아무 작업도 수행하지 않음
                    } label: {
                        Text("저장")
                            .foregroundStyle(isActive ? .white : .gray) // 활성화 상태에 따라 텍스트 색상 변경
                            .font(.system(size: 16))
                    }
                    .disabled(!isActive) // 버튼 비활성화 여부 결정
                    .onChange(of: viewModel.changedValue) { newValue, oldValue in
                        isActive = !newValue // viewModel의 changedValue에 따라 isActive 상태 업데이트
                    }
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
            
            .onAppear {
                viewModel.fetchUserProfile()
            }
            .onDisappear {
                viewModel.imagePick = false
                viewModel.backimagePick = false
                viewModel.userSelectImage = nil
                viewModel.backSelectImage = nil
            }
        }
    }
}
