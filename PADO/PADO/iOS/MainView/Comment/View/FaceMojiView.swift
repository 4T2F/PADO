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
    @State var facemojies: [Facemoji] = []
    let post: Post
    let updatePushNotiData: UpdatePushNotiData
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(facemojies, id: \.self) { facemoji in
                        FaceMojiCell(facemoji: facemoji, feedVM: feedVM)
                            .padding(.horizontal, 6)
                            .sheet(isPresented: $feedVM.deleteFacemojiModal) {
                                DeleteFaceMojiView(facemoji: feedVM.selectedFacemoji ?? facemoji, feedVM: feedVM)
                                    .presentationDetents([.medium])
                            }
                    }
                    Button {
                        // 페이스모지 열기
//                        surfingVM.checkCameraPermission {
//                            surfingVM.isShownCamera.toggle()
//                            surfingVM.sourceType = .camera
//                            surfingVM.cameraDevice = .front
//                        }
                        surfingVM.isShowingFaceMojiModal = true
                    } label: {
                        VStack {
                            Image("face.dashed")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .padding(.vertical, 16)
                            
                            Text("")
                            
                        }
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $surfingVM.isShowingFaceMojiModal) {
                        FaceMojiModalView(surfingVM: surfingVM)
                            .presentationDetents([.fraction(0.3)])
                            
                    }
                    .sheet(isPresented: $surfingVM.isShownCamera) {
                        CameraAccessView(isShown: $surfingVM.isShownCamera,
                                         myimage: $surfingVM.faceMojiImage,
                                         myUIImage: $surfingVM.faceMojiUIImage,
                                         mysourceType: $surfingVM.sourceType,
                                         mycameraDevice: $surfingVM.cameraDevice)
                    }
                    .onChange(of: surfingVM.faceMojiUIImage) { _, _ in
                        surfingVM.isShowingFaceMojiModal = false
                        feedVM.faceMojiUIImage = surfingVM.faceMojiUIImage
                        feedVM.showCropFaceMoji = true
                    }
                    
                    
//                    .sheet(isPresented: $surfingVM.isShownCamera) {
//                        CameraAccessView(isShown: $surfingVM.isShownCamera,
//                                         myimage: $surfingVM.faceMojiImage,
//                                         myUIImage: $surfingVM.faceMojiUIImage,
//                                         mysourceType: $surfingVM.sourceType,
//                                         mycameraDevice: $surfingVM.cameraDevice)
////                        .onAppear {
////                            Task {
////                                self.postOwner = await UpdateUserData.shared.getOthersProfileDatas(id: feedVM.feedOwnerProfileID)
////                            }
////                        }
//                        .onDisappear {
//                            feedVM.faceMojiUIImage = surfingVM.faceMojiUIImage
//                            feedVM.showCropFaceMoji = true
//                            //                        Task {
//                            //                            try await feedVM.updateFaceMoji()
//                            //                            try await feedVM.getFaceMoji()
//                            //                            await updatePushNotiData.pushNoti(receiveUser: postOwner!, type: .facemoji)
//                            //                        }
//                        }
//                    }
                    .navigationDestination(isPresented: $feedVM.showCropFaceMoji) {
                        FaceMojiCropView(feedVM: feedVM,
                                         surfingVM: surfingVM) { croppedImage, status in
                            if let croppedImage {
                                feedVM.cropMojiUIImage = croppedImage
                            }
                        }
                    }
                }
            }
        }
    }
}
