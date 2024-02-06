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
    
    @Binding var postOwner: User
    
    let post: Post
    let postID: String
 
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(feedVM.facemojies, id: \.self) { facemoji in
                        FaceMojiCell(facemoji: facemoji, feedVM: feedVM)
                            .padding(.horizontal, 6)
                            .sheet(isPresented: $feedVM.deleteFacemojiModal) {
                                DeleteFaceMojiView(facemoji: feedVM.selectedFacemoji ?? facemoji, 
                                                   postID: postID,
                                                   feedVM: feedVM)
                                    .presentationDetents([.medium])
                            }
                    }
                    Button {
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
                    .onAppear {
                        Task {
                            feedVM.facemojies = try await feedVM.updateFacemojiData.getFaceMoji(documentID: postID) ?? []
                        }
                    }
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
                    .navigationDestination(isPresented: $feedVM.showCropFaceMoji) {
                        FaceMojiCropView(feedVM: feedVM,
                                         surfingVM: surfingVM,
                                         postID: postID) { croppedImage, status in
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
