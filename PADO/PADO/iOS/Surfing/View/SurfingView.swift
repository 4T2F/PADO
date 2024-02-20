//
//  SurfingView.swift
//  PADO
//
//  Created by 황성진 on 1/23/24.
//

import Photos
import PhotosUI
import SwiftUI

struct SurfingView: View {
    // MARK: - PROPERTY
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                Color.main.ignoresSafeArea()
                if followVM.followingIDs.isEmpty {
                    Spacer()
                    
                    Text("내가 팔로잉한 사람이 없어요")
                        .font(.system(size: 16, weight: .bold))
                    
                    FeedGuideView(feedVM: feedVM)
                    
                    Spacer()
                } else if followVM.surfingIDs.isEmpty {
                    Spacer()
                    
                    SurfingGuideView()
                    
                    Spacer()
                } else {
                    VStack {
                        Spacer()
                        
                        Button {
                            surfingVM.isShowingPhotoModal = true
                        } label: {
                            // 이미 선택된 이미지를 표시하는 영역
                            if surfingVM.selectedUIImage != Image(systemName: "photo") {
                                surfingVM.selectedUIImage
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8)
                                    .scaledToFit()
                                
                            } else if surfingVM.cameraImage != Image(systemName: "photo") {
                                surfingVM.cameraImage
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8)
                                    .scaledToFit()
                            } else {
                                Text("이미지를 선택하세요.")
                                    .padding(.top, 30)
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8)
                                    .background(Color.gray)
                            }
                        }
                    }
                    .navigationTitle("새로운 파도")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color.main, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .background {
                        Color.main
                            .ignoresSafeArea()
                    }
                    .onChange(of: surfingVM.selectedUIImage) { oldValue, newValue in
                        surfingVM.isShowingPhotoModal = false
                    }
                    .onAppear {
                        surfingVM.checkPhotoLibraryPermission()
                    }
                    .alert(isPresented: $surfingVM.showingPermissionAlert) {
                        Alert(title: Text("권한 필요"), message: Text("사진 라이브러리 접근 권한이 필요합니다."), dismissButton: .default(Text("확인")))
                    }
                    .sheet(isPresented: $surfingVM.isShownCamera) {
                        CameraAccessView(isShown: $surfingVM.isShownCamera,
                                         myimage: $surfingVM.cameraImage,
                                         myUIImage: $surfingVM.cameraUIImage,
                                         mysourceType: $surfingVM.sourceType,
                                         mycameraDevice: $surfingVM.cameraDevice)
                    }
                    .onDisappear {
                        surfingVM.isShownCamera = false
                    }
                    .sheet(isPresented: $surfingVM.isShowingPhotoModal, content: {
                        PhotoTypeModal(surfingVM: surfingVM,
                                       feedVM: feedVM,
                                       profileVM: profileVM)
                        .presentationDetents([.fraction(0.3)])
                        .presentationDragIndicator(.visible)
                        
                    })
                    .navigationDestination(isPresented: $surfingVM.showCropView) {
                        PostCropView(surfingVM: surfingVM,
                                     feedVM: feedVM,
                                     profileVM: profileVM,
                                     followVM: followVM) { croppedImage, status in
                            if let croppedImage {
                                surfingVM.postingUIImage = croppedImage
                            }
                        }
                    }
                    .toolbar {
                        // 다음 버튼을 toolbarItem으로 추가
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if followVM.followingIDs.isEmpty {
                                Spacer()
                                
                                Text("팔로잉한 사람이 없어요")
                                    .font(.system(size: 16, weight: .bold))
                                
                                FeedGuideView(feedVM: feedVM)
                                
                                Spacer()
                            } else if followVM.surfingIDs.isEmpty {
                                Spacer()
                                
                                Text("서퍼로 지정해준 사람이 없어요")
                                    .font(.system(size: 16, weight: .bold))
                                
                                SurfingGuideView()
                                
                                Spacer()
                            } else {
                                if surfingVM.cameraImage != Image(systemName: "photo") || surfingVM.selectedUIImage != Image(systemName: "photo") {
                                    // 변경될 수 있음
                                    Button("다음") {
                                        if surfingVM.cameraImage != Image(systemName: "photo") {
                                            surfingVM.postingImage = surfingVM.cameraImage
                                            surfingVM.postingUIImage = surfingVM.cameraUIImage
                                        } else if surfingVM.selectedUIImage != Image(systemName: "photo") {
                                            surfingVM.postingImage = surfingVM.selectedUIImage
                                            surfingVM.postingUIImage = surfingVM.selectedImage ?? UIImage()
                                        }
                                        surfingVM.showCropView.toggle()
                                    }
                                    .font(.system(size: 16, weight: .semibold))
                                } else {
                                    Button {
                                        
                                    } label: {
                                        Text("다음")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
