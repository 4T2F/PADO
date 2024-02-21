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
    
    var body: some View {
        VStack {
            VStack {
                Button {
                    surfingVM.isShowingPhotoModal = false
                } label: {
                    HStack {
                        PhotosPicker(selection: $surfingVM.postImageItem) {
                            Text("사진앨범")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Image(systemName: "photo")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical, 6)
                
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
                    HStack {
                        Text("카메라")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Image(systemName: "camera")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .background(.modalCell)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(15)
            .onAppear {
                surfingVM.checkPhotoLibraryPermission()
            }
            
            Button {
                surfingVM.isShowingPhotoModal = false
            } label: {
                HStack {
                    Spacer()
                    
                    Text("취소")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                     
                    Spacer()
                }
            }
            .padding()
            .background(.modalCell)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 15)
        }
    }
}
