//
//  FaceMoji.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct FaceMojiView: View {
    @ObservedObject var surfingVM: SurfingViewModel
    
    let emotions: [Emotion] = Emotion.allCases
    let users: [String] = ["DogStar", "Hsunjin", "pinkSo"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(zip(emotions, users)), id: \.0.self) { (emotion, user) in
                        FaceMojiCell(emotion: emotion, faceMojiUser: user)
                            .padding(.horizontal, 6)
                }
                Button {
                    // 페이스모지 열기
                    surfingVM.checkCameraPermission {
                        surfingVM.isShownCamera.toggle()
                        surfingVM.sourceType = .camera
                        surfingVM.pickerResult = []
                        surfingVM.selectedImage = nil
                        surfingVM.selectedUIImage = Image(systemName: "photo")
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
                    CameraAccessView(isShown: $surfingVM.isShownCamera, myimage: $surfingVM.cameraImage, myUIImage: $surfingVM.cameraUIImage, mysourceType: $surfingVM.sourceType)
                }

            }
        }
    }
}
