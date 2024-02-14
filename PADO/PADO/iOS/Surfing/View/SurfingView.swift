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
            VStack {
                HStack {
                    Spacer()
 
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
                        .padding(.trailing, 17)
                        .padding(.top, 12)
                        .font(.system(size: 16, weight: .semibold))
                    } else {
                        Button {
                            
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.gray)
                                .padding(.top, 12)
                                .padding(.trailing, 17)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    surfingVM.isShowingPhotoModal.toggle()
                } label: {
                    // 이미 선택된 이미지를 표시하는 영역
                    if surfingVM.selectedUIImage != Image(systemName: "photo") {
                        surfingVM.selectedUIImage
                            .resizable()
                            .scaledToFit()
                        
                    } else if surfingVM.cameraImage != Image(systemName: "photo") {
                        surfingVM.cameraImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("이미지를 선택하세요.")
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.75)
                            .background(Color.gray)
                    }
                }

                Spacer()
                
            } //: VSTACK
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
                PhotoTypeModal(surfingVM: surfingVM, feedVM: feedVM, profileVM: profileVM, followVM: followVM)
                    .presentationDetents([.fraction(0.25)])
                    
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
        }
    }
}
