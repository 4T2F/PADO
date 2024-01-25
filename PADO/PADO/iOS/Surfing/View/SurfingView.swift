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
    @ObservedObject var viewModel = SurfingViewModel()
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // 이미 선택된 이미지를 표시하는 영역
                if viewModel.selectedUIImage != Image(systemName: "photo") {
                    viewModel.selectedUIImage
                        .resizable()
                        .scaledToFit()

                } else if viewModel.cameraImage != Image(systemName: "photo") {
                    viewModel.cameraImage
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
                        viewModel.checkCameraPermission {
                            viewModel.isShownCamera.toggle()
                            viewModel.sourceType = .camera
                            viewModel.pickerResult = []
                            viewModel.selectedImage = nil
                            viewModel.selectedUIImage = Image(systemName: "photo")
                        }
                    } label: {
                        Image("Camera")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    if viewModel.cameraImage != Image(systemName: "photo") {
                        Button {
                            viewModel.postingImage = viewModel.cameraImage
                            viewModel.showPostView.toggle()
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    } else if viewModel.selectedUIImage != Image(systemName: "photo") {
                        Button {
                            viewModel.postingImage = viewModel.selectedUIImage
                            viewModel.showPostView.toggle()
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                
                PhotoPicker(pickerResult: $viewModel.pickerResult,
                            selectedImage: $viewModel.selectedImage,
                            selectedSwiftUIImage: $viewModel.selectedUIImage)
                    .frame(height: 300)
                
            } //: VSTACK
            .onAppear {
                viewModel.checkPhotoLibraryPermission()
            }
            .alert(isPresented: $viewModel.showingPermissionAlert) {
                Alert(title: Text("권한 필요"), message: Text("사진 라이브러리 접근 권한이 필요합니다."), dismissButton: .default(Text("확인")))
            }
            .sheet(isPresented: $viewModel.isShownCamera) {
                CameraAccessView(isShown: $viewModel.isShownCamera, myimage: $viewModel.cameraImage, mysourceType: $viewModel.sourceType)
            }
        }
        .navigationDestination(isPresented: $viewModel.showPostView) {
            PostView(viewModel: viewModel)
        }//: NAVI
    }
}
