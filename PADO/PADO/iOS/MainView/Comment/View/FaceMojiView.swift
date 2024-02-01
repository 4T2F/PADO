//
//  FaceMoji.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct FaceMojiView: View {
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var surfingVM: SurfingViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(feedVM.facemojies, id: \.self) { facemoji in
                    FaceMojiCell(facemoji: facemoji)
                        .padding(.horizontal, 6)
                }
                Button {
                    // 페이스모지 열기
                    surfingVM.checkCameraPermission {
                        surfingVM.isShownCamera.toggle()
                        surfingVM.sourceType = .camera
                        surfingVM.cameraDevice = .front
                    }
                } label: {
                    VStack {
                        Image("face.dashed")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                        
                        Text("")
                        
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $surfingVM.isShownCamera) {
                    CameraAccessView(isShown: $surfingVM.isShownCamera,
                                     myimage: $surfingVM.faceMojiImage,
                                     myUIImage: $surfingVM.faceMojiUIImage,
                                     mysourceType: $surfingVM.sourceType,
                                     mycameraDevice: $surfingVM.cameraDevice)
                    .onDisappear() {
                        feedVM.faceMojiImage = surfingVM.faceMojiImage
                        feedVM.faceMojiUIImage = surfingVM.faceMojiUIImage
                        Task {
                            try await feedVM.updateFaceMoji()
                            try await feedVM.getFaceMoji()
                        }
                    }
                }
            }
        }
    }
}
