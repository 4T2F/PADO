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
                Spacer()
                
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray)
                }
                
                Spacer()
                
                // 이미지 피커 버튼을 표시하는 영역
                HStack {
                    Button {
                        surfingVM.checkCameraPermission {
                            surfingVM.isShownCamera.toggle()
                            surfingVM.sourceType = .camera
                            surfingVM.pickerResult = []
                            surfingVM.selectedImage = nil
                            surfingVM.selectedUIImage = Image(systemName: "photo")
                        }
                    } label: {
                        Image("Camera")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    if surfingVM.cameraImage != Image(systemName: "photo") {
                        Button {
                            surfingVM.postingImage = surfingVM.cameraImage
                            surfingVM.postingUIImage = surfingVM.cameraUIImage
                            surfingVM.showCropView.toggle()
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    } else if surfingVM.selectedUIImage != Image(systemName: "photo") {
                        Button {
                            surfingVM.postingImage = surfingVM.selectedUIImage
                            surfingVM.postingUIImage = surfingVM.selectedImage ?? UIImage()
                            surfingVM.showCropView.toggle()
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                
                PhotoPicker(pickerResult: $surfingVM.pickerResult,
                            selectedImage: $surfingVM.selectedImage,
                            selectedSwiftUIImage: $surfingVM.selectedUIImage)
                    .frame(height: 300)
                
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
        }
        .navigationDestination(isPresented: $surfingVM.showCropView) {
            PostCropView(surfingVM: surfingVM,
                         feedVM: feedVM,
                         profileVM: profileVM,
                         followVM: followVM) { croppedImage, status in
                if let croppedImage {
                    surfingVM.postingUIImage = croppedImage
                }
            }
        }//: NAVI
    }
}
