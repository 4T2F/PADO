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
            PhotosPicker(selection: $surfingVM.faceMojiItem) {
                Text("사진앨범")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.grayButton)
                .cornerRadius(10)}
            .padding(.vertical)
            
            Button {
                surfingVM.isShowingFaceMojiModal = false
                surfingVM.checkCameraPermission {
                    surfingVM.isShownCamera = true
                    surfingVM.sourceType = .camera
                    surfingVM.cameraDevice = .front
                }
            } label: {
                Text("카메라")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.grayButton)
                    .cornerRadius(10)
            }
        }
    }
}
