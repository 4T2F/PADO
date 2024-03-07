//
//  PhotoMojiModal.swift
//  PADO
//
//  Created by 김명현 on 2/6/24.
//
import PhotosUI
import SwiftUI

struct PhotoMojiModalView: View {
    @ObservedObject var surfingVM: SurfingViewModel
    
    var body: some View {
        VStack {
            VStack{
                HStack {
                    PhotosPicker(selection: $surfingVM.photoMojiItem,
                                 matching: .images) {
                        Text("사진앨범")
                            .font(.system(.subheadline))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "photo")
                            .font(.system(.subheadline))
                            .fontWeight(.bold)
                    }
                }
                
                Divider()
                    .padding(.vertical, 6)
                
                Button {
                    surfingVM.isShowingPhotoMojiModal = false
                    surfingVM.checkCameraPermission {
                        surfingVM.isShownCamera = true
                        surfingVM.sourceType = .camera
                        surfingVM.cameraDevice = .front
                    }
                } label: {
                    HStack {
                        Text("카메라")
                            .font(.system(.subheadline))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "camera")
                            .font(.system(.subheadline))
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .background(.modalCell)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(15)
            
            Button {
                surfingVM.isShowingPhotoMojiModal = false
            } label: {
                HStack {
                    Spacer()
                    
                    Text("취소")
                        .font(.system(.subheadline))
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
