//
//  FaceMojiModal.swift
//  PADO
//
//  Created by 김명현 on 2/6/24.
//
import PhotosUI
import SwiftUI

struct FaceMojiModalView: View {
    @ObservedObject var surfingVM: SurfingViewModel
    
    var body: some View {
        VStack {
            VStack{
                HStack {
                    PhotosPicker(selection: $surfingVM.faceMojiItem) {
                        Text("사진앨범")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "photo")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                    }
                }
                
                Divider()
                    .padding(.vertical, 6)
                
                Button {
                    surfingVM.isShowingFaceMojiModal = false
                    surfingVM.checkCameraPermission {
                        surfingVM.isShownCamera = true
                        surfingVM.sourceType = .camera
                        surfingVM.cameraDevice = .front
                    }
                } label: {
                    HStack {
                        Text("카메라")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        
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
            
            Button {
                surfingVM.isShowingFaceMojiModal = false
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
