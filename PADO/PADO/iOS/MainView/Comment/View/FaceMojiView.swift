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
    
    @State private var postOwner: User? = nil
    
    let updatePushNotiData = UpdatePushNotiData()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(feedVM.facemojies, id: \.self) { facemoji in
                    FaceMojiCell(facemoji: facemoji, feedVM: feedVM)
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
                            .padding(.vertical, 8)
                        
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
                    .onAppear {
                        Task {
                            self.postOwner = await UpdateUserData.shared.getOthersProfileDatas(id: feedVM.feedOwnerProfileID)
                        }
                    }
                    .onDisappear {
                        feedVM.faceMojiImage = surfingVM.faceMojiImage
                        feedVM.faceMojiUIImage = surfingVM.faceMojiUIImage
                        Task {
                            try await feedVM.updateFaceMoji()
                            try await feedVM.getFaceMoji()
                            await updatePushNotiData.pushNoti(receiveUser: postOwner!, type: .facemoji)
                        }
                    }
                }
            }
        }
    }
}
