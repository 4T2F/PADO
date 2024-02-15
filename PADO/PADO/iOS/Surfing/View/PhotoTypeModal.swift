//
//  PhotoTypeModal.swift
//  PADO
//
//  Created by 김명현 on 2/14/24.
//

import PhotosUI
import SwiftUI

struct PhotoTypeModal: View {
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    
    var body: some View {
        VStack {
            Button {
                surfingVM.isShowingPhotoModal = false
            } label: {
                PhotosPicker(selection: $surfingVM.postImageItem) {
                    Text("사진앨범")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .background(.grayButton)
                        .cornerRadius(10)
                }
                .onChange(of: surfingVM.postImageItem) { _, _ in
                    surfingVM.isShowingPhotoModal = false
                }
            }
            .padding(.vertical, 15)
            
            Button {
                surfingVM.checkCameraPermission {
                    surfingVM.isShowingPhotoModal = false
                    surfingVM.isShownCamera.toggle()
                    surfingVM.sourceType = .camera
                    surfingVM.pickerResult = []
                    surfingVM.selectedImage = nil
                    surfingVM.selectedUIImage = Image(systemName: "photo")
                }
            } label: {
                Text("카메라")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.grayButton)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            surfingVM.checkPhotoLibraryPermission()
        }
    }
}
